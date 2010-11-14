$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'cli/runner'
require 'cli/command'

# load core extensions
#Dir['core_ext/**/*.rb'].each {|f| require f}

# load commands
Dir[File.expand_path(File.join(File.dirname(__FILE__),'cli','command','**','*.rb'))].each do |f| 
  require f
end

# execute command
Track::CLI::Runner.new(ARGV).run