module Track
  module CLI

    class Stop < Command
      
      self.uri_path = "/1/logs/:id"
      
      report_as do |r| 
        "#{r['project']['name']} - #{r['task']} (#{r['id']}) spent #{r['duration'].to_i.seconds_to_hhmm}" 
      end
      
      # note currently id must be passed
      def parse!
        @params['id'] = @argv.shift
      end
      
      def run
        render put
      end
            
    end

  end
end