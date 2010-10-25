require 'rubygems'

require 'minitest/spec'
MiniTest::Unit.autorun

require 'rack/test'
ENV['RACK_ENV'] = 'test'

require 'sinatra'
#Sinatra::Base.set :environment, :test

# Helper modules
Dir[File.join(File.dirname(__FILE__),'shared','**','*.rb')].each do |f|
  require f
end

require File.join(File.dirname(__FILE__), '..', 'lib', 'trackd')


