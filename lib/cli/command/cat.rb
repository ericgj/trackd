module Track
  module CLI

    class Cat < Command
      
      self.uri_path = "/1/projects"
      
      # TODO class to do table formatting...
      report_as do |recs| 
        recs.map do |r|
          ["#{r['name']}"] + \
            r['logs'].map do |log|
              "  #{log['task']}   #{log['duration'].to_i.seconds_to_hhmm}"
            end
        end.flatten
      end
            
      def run
        render get
      end
            
    end

  end
end