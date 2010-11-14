$LOAD_PATH.unshift curdir = File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'cli/runner'
require 'cli/command'

# load core extensions
Dir[File.join(curdir,'core_ext','**','*.rb')].each {|f| require f}

# load commands
Dir[File.join(curdir,'cli','command','**','*.rb')].each do |f| 
  require f
end

# execute command
Track::CLI::Runner.new(ARGV).run