begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification...
  # see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = 'paid_up'
  gem.homepage = 'http://www.gemvein.com/museum/cases/paid_up'
  gem.license = 'MIT'
  gem.summary = 'Allows a model of your choosing to subscribe to a plan, which'\
                  ' enables features.'
  gem.description = 'Allows a model of your choosing (such as users) to '\
                      'subscribe to a plan, which enables features.'
  gem.email = 'karen.e.lundgren@gmail.com'
  gem.authors = ['Karen Lundgren']
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task default: :spec
