module Track
  module CLI

    class Start < Command
      
      self.uri_path = "/1/projects/:project/logs"
      
      report_as do |r| 
        "#{r['project']['name']} - #{r['task']} started at #{r['started_at']}" 
      end
      
      def parse!
        @params['project'] = @argv.shift
        @params['task'] = @argv.join(' ')
      end
      
      def run
        handle_response post(uri, {'task' => @params['task']})
      end
            
    end

  end
end