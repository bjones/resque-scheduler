# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resque_scheduler/version'

Gem::Specification.new do |spec|
  spec.name        = 'resque-scheduler'
  spec.version     = ResqueScheduler::VERSION
  spec.authors     = ['Ben VandenBos']
  spec.email       = ['bvandenbos@gmail.com']
  spec.homepage    = 'http://github.com/resque/resque-scheduler'
  spec.summary     = 'Light weight job scheduling on top of Resque'
  spec.description = %q{Light weight job scheduling on top of Resque.
    Adds methods enqueue_at/enqueue_in to schedule jobs in the future.
    Also supports queueing jobs on a fixed, cron-like schedule.}

  spec.files        = `git ls-files`.split("\n")
  spec.executables  = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files   = spec.files.grep(%r{^test/})
  spec.require_path = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rake'
  unless RUBY_VERSION < '1.9'
    spec.add_development_dependency 'rubocop'
  end

  spec.add_runtime_dependency 'redis', '>= 2.0.1'
  spec.add_runtime_dependency 'resque', ['>= 1.8.0']
  spec.add_runtime_dependency 'rufus-scheduler', '>= 0'
end
