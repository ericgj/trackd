require 'rubygems'

require 'minitest/spec'
MiniTest::Unit.autorun

require 'rack/test'
ENV['RACK_ENV'] = 'test'

require 'sinatra'
Sinatra::Base.set :environment, :test

require File.join(File.dirname(__FILE__), '..', 'lib', 'trackd')


