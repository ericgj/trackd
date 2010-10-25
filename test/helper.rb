require File.join(File.dirname(__FILE__),'test_helper')

require 'rack/test'
ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', 'lib', 'trackd')

# Helper modules
Dir[File.join(File.dirname(__FILE__),'shared','**','*.rb')].each do |f|
  require f
end

