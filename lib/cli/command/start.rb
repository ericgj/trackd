module Track
  module CLI

    class Start < Command
      
      self.uri_path = "/1/projects/:project/logs"
      
      report_as do |r| 
        "#{r['project']['name']} - #{r['task']} (#{r['id']}) started at #{r['started_at']}" 
      end
      
      def parse!
        @params['project'] = @argv.shift
        @params['task'] = @argv.join(' ')
      end
      
      def run
        render post(uri, {'task' => @params['task']})
      end
            
    end

  end
end