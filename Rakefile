require 'rubygems'
require 'rake'
require File.join(File.dirname(__FILE__), "lib", "trackd", "version")

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  #version = File.exist?('VERSION') ? File.read('VERSION') : ""
  version = Trackd::VERSION
  
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "trackd #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


namespace 'db' do

  task 'create' do
    #TODO: look up storage file name in YAML based on environment
    `sqlite3 lib/trackd/db/#{ENV['RACK_ENV']}.sqlite3 'select sqlite_version(*)'`
  end
  
  task 'auto_migrate' => 'db:create' do
    #TODO: look up db options in YAML based on environment
  end
 
end


task :test => :check_dependencies

task :default => :test

