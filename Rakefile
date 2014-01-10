#!/usr/bin/env rake
require 'bundler'
Bundler::GemHelper.install_tasks
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'Run specs'
task :default => :spec

task :test => :spec