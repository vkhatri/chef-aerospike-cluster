#!/usr/bin/env rake

require 'foodcritic'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

desc 'Run all lints'
task :lint => %w(foodcritic rubocop)
# task :lint => %w(foodcritic rubocop knife spec)
task :default => :lint

desc 'Run Rubocop Lint Task'
RuboCop::RakeTask.new

desc 'Run Foodcritic Lint Task'
task :foodcritic do
  puts 'Running Foodcritic Lint..'
  FoodCritic::Rake::LintTask.new do |fc|
    fc.options = { :fail_tags => ['any'] }
  end
end

desc 'Run Knife Cookbook Test Task'
task :knife do
  puts 'Running Knife Check..'
  current_dir = File.expand_path(File.dirname(__FILE__))
  cookbook_dir = File.dirname(current_dir)
  cookbook_name = File.basename(current_dir)
  sh "bundle exec knife cookbook test -o #{cookbook_dir} #{cookbook_name}"
end

desc 'Run Chef Spec Test'
task :spec do
  RSpec::Core::RakeTask.new(:spec)
end

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
end

namespace 'kitchen:suite' do
  desc 'run default tests'
  task :default do
    # instances = Kitchen::Config.new.instances.select { |instance| instance.name.include?('default') }
    instances =  Kitchen::Config.new.instances.get_all(/default/)
    # always cleanup before and after
    instances.each {|instance| instance.test(:always)}
  end

  Kitchen::Config.new.suites.get_all(/^(?!default)/).each do |suite|
    desc "Run group of #{suite.name} suite tests"
    task suite.name.to_sym do
      # instances = Kitchen::Config.new.instances.select { |instance| instance.name.include?('multicast') }
      instances = Kitchen::Config.new.instances.get_all(/#{suite.name}/)
      # Cleanup before
      instances.map(&:destroy)
      # Do converge before cluster verify
      instances.map(&:converge)
      # Verify
      instances.map(&:verify)
      # Cleanup after
      instances.map(&:destroy)
    end
  end

  desc 'Run all test suites'
  task :all => Kitchen::Config.new.suites.map(&:name).map {|s| 'kitchen:suite:' + s}

  desc 'Run community-* test suites'
  task :community_all => Kitchen::Config.new.suites.get_all(/community/).map(&:name).map {|s| 'kitchen:suite:' + s}

  desc 'Run community-tarball-* test suites'
  task :community_tarball_all => Kitchen::Config.new.suites.get_all(/community-tarball/).map(&:name).map {|s| 'kitchen:suite:' + s}

  desc 'Run community-package-* test suites'
  task :community_package_all => Kitchen::Config.new.suites.get_all(/community-package/).map(&:name).map {|s| 'kitchen:suite:' + s}
end


