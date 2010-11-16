module Track
  module CLI

    class Stop < Command
      
      self.uri_path = "/1/current/logs"
      
      report_as do |r| 
        "(#{r['id']}) #{r['project']['name']} - #{r['task']} spent #{r['duration'].to_i.seconds_to_hhmm}" 
      end
      
      def parse!
        if @argv
          @params['message'] = @argv.join(' ')
          self.class.uri_path += '?message=:message'
        end
      end
      
      def run
        render put
      end
            
    end

  end
end