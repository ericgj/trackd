$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'trackd'

require 'minitest/spec'
MiniTest::Unit.autorun

require 'rack/test'
ENV['RACK_ENV'] = 'test'

