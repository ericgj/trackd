$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
Bundler.setup :default

require 'sinatra/base'
require 'trackd/app'
