require 'rubygems'
require 'rake'
require File.join(File.dirname(__FILE__), "lib", "trackd", "version")

PROJECT_ROOT = File.expand_path(File.dirname(__FILE__))
SINATRA_ROOT = File.join(PROJECT_ROOT, 'lib', 'trackd')

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
  
  require 'dm-core'
  require 'dm-migrations'
  
  task 'create' do
    #TODO: look up storage file name in YAML based on environment
    `sqlite3 db/#{ENV['RACK_ENV']}.sqlite3 'select sqlite_version(*)'`
  end

  task 'setup' do
    db = "sqlite3://#{PROJECT_ROOT}/db/#{ENV['RACK_ENV']}.sqlite3"
    DataMapper::Logger.new(File.join(PROJECT_ROOT,'log', "#{ENV['RACK_ENV']}.log"), :debug)
    DataMapper.setup(:default, db)
    Dir[File.join(SINATRA_ROOT,'models','**','*.rb')].each do |f|
      require f
    end      
  end
  
  task 'auto_migrate' => 'db:setup' do
    DataMapper.auto_migrate!
    DataMapper.finalize
  end
 
end


task :test => :check_dependencies

task :default => :test

