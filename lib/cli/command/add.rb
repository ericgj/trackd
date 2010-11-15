module Track
  module CLI

    class Add < Command
      
      self.uri_path = "/1/projects/:project/logs?task=:task&time=:time"
      
      report_as do |r| 
        "(#{r['id']}) #{r['project']['name']} - #{r['task']} added #{r['duration'].to_i.seconds_to_hhmm}" 
      end
      
      # note currently id must be passed
      def parse!
        t = @argv.shift
        @params['time'] = t.hhmm_to_seconds || t
        @params['project'] = @argv.shift
        @params['task'] = @argv.join(' ') || ''
      end
      
      def run
        render put
      end
            
    end

  end
end