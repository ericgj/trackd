$LOAD_PATH.unshift curdir = File.expand_path(File.dirname(__FILE__))

require 'rubygems'
#require 'bundler'
#Bundler.setup :default

require 'sinatra/base'
#require 'json-pure'
require 'dm-core'
require 'dm-migrations'
require 'dm-serializer'
require 'dm-transactions'

# load core extensions before app but after gems
Dir[File.join(curdir,'core_ext','**','*.rb')].each {|f| require f}

require 'trackd/app'
