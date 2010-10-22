$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'
#require 'bundler'
#Bundler.setup :default

require 'sinatra/base'
require 'json-pure'
require 'dm-core'
require 'dm-migrations'
require 'trackd/app'
