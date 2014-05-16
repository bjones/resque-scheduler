require 'resque/scheduler/lock/base'

module Resque
  class Scheduler
    module Lock
      class Resilient < Base
        def acquire!
          refresh = false
          begin
            Resque.redis.evalsha(
              acquire_sha(refresh),
              :keys => [key],
              :argv => [value]
            ).to_i == 1
          rescue Exception => e
            if e.message =~ /NOSCRIPT/
              refresh = true
              retry
            end
            raise
          end
        end

        def locked?
          refresh = false
          begin
            Resque.redis.evalsha(
              locked_sha(refresh),
              :keys => [key],
              :argv => [value]
            ).to_i == 1
          rescue Exception => e
            if e.message =~ /NOSCRIPT/
              refresh = true
              retry
            end
            raise
          end
        end

        private

        def locked_sha(refresh = false)
          @locked_sha = nil if refresh

          @locked_sha ||= begin
            Resque.redis.script(
              :load,
              <<-EOF
if redis.call('GET', KEYS[1]) == ARGV[1]
then
  redis.call('EXPIRE', KEYS[1], #{timeout})

  if redis.call('GET', KEYS[1]) == ARGV[1]
  then
    return 1
  end
end

return 0
EOF
            )
          end
        end

        def acquire_sha(refresh = false)
          @acquire_sha = nil if refresh

          @acquire_sha ||= begin
            Resque.redis.script(
              :load,
              <<-EOF
if redis.call('SETNX', KEYS[1], ARGV[1]) == 1
then
  redis.call('EXPIRE', KEYS[1], #{timeout})
  return 1
else
  return 0
end
EOF
            )
          end
        end
      end
    end
  end
end
