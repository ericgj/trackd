module Track
  module CLI

    class Cat < Command
      
      self.uri_path = "/1/logs"
      
      # TODO class to do table formatting...
      report_as do |recs| 
        lastdt = nil
        recs.map do |r|
          t0 = Time.parse(r['started_at']) if r['started_at']
          t1 = Time.parse(r['stopped_at']) if r['stopped_at']
          dt = Date.civil(t0.year, t0.month, t0.day) if t0
          lines = []
          unless lastdt == dt
            lines << "#{dt.strftime('%a %d %b %Y') if dt}"
          end
          lines << "  #{t0 ? t0.strftime('%I:%M%p') : '-------'}  #{t1 ? t1.strftime('%I:%M%p') : '-------'}  #{r['duration'].to_i / 60}  #{r['project']['name']}  #{r['task']}"
          lines << "    #{r['message']}" if r['message']
          lastdt = dt
          lines
        end.flatten
      end
            
      def run
        render get
      end
            
    end

  end
end