module Track
  module CLI

    class Restart < Command
      
      self.uri_path = "/1/last/logs"
      
      report_as do |r| 
        "(#{r['id']}) #{r['project']['name']} - #{r['task']} restarted at #{r['started_at']}" 
      end
      
      def run
        render post
      end
            
    end

  end
end