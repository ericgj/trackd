require 'optparse'
require 'active_support/inflector'

module Track
  module CLI
    
    class Runner
      COMMANDS            = %w(start stop restart add sub cat)
      
      DEFAULT_HOST = 'localhost'
      DEFAULT_PORT = 2003
      
      def self.commands
        COMMANDS
      end

      def initialize(argv)
        @argv = argv
        
        # Default options values
        @options = { 
                    :address => DEFAULT_HOST, 
                    :port => DEFAULT_PORT
                   }
              
        parse!
      end
      
      def parser
        @parser ||= OptionParser.new do |opts|
          opts.banner = "Usage: track [options] (#{self.class.commands.join('|')}) [params]"

          opts.separator ""
          opts.separator "Options:"

          opts.on("-a", "--address HOST", "use HOST address " +
                                          "(default: #{@options[:address]})")             { |host| @options[:address] = host }    
          opts.on("-p", "--port PORT", "use PORT (default: #{@options[:port]})")          { |port| @options[:port] = port.to_i }
          opts.on_tail("-h", "--help", "Show this message")                               { puts opts; exit }
          
          opts.separator ""
          opts.separator "Commands:"
          opts.separator "  start [project] [task]       Start timing project/task"
          opts.separator "  stop                         Stop timing last project/task"
          opts.separator "  restart                      Restart last project/task"
          opts.separator "  add [time] [project] [task]  Add time (hh:mm)"
          opts.separator "  sub [time] [project] [task]  Subtract time (hh:mm)"
          opts.separator "  cat                          List logged times"
        end
        
      end
      
      def parse!
        parser.parse! @argv
        @command   = @argv.shift
        @params = @argv    
      end
      
      def run
        if self.class.commands.include?(@command)
          run_command
        elsif @command.nil?
          puts "Command required"
          puts @parser
          exit 1  
        else
          abort "Unknown command: #{@command}. Use one of #{self.class.commands.join(', ')}"
        end
      end

      def run_command
        klass = "Track::CLI::#{@command.titleize}".constantize
        klass.base_uri = "http://#{@options[:address]}:#{@options[:port]}/"
        klass.new(@params).run
      end
      
      
    end

   
  end
end

