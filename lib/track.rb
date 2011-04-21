$LOAD_PATH.unshift curdir = File.expand_path(File.dirname(__FILE__))

require 'rubygems'

# load core extensions
Dir[File.join(curdir,'core_ext','**','*.rb')].each {|f| require f}

# load helpers
Dir[File.join(curdir,'helpers','**','*.rb')].each {|f| require f}

require 'cli/runner'
require 'cli/command'

# load commands
Dir[File.join(curdir,'cli','command','**','*.rb')].each do |f| 
  require f
end

# execute command
Track::CLI::Runner.new(ARGV).run