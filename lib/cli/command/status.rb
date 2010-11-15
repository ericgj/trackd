require 'time'

module Track
  module CLI

    class Status < Command
      extend Track::Helpers::DateHelper

      self.uri_path = "/1/status"
      
      # TODO class to do table formatting...
      report_as do |r| 
        ["Server uptime:     #{r['server_uptime'].to_i.seconds_to_hhmm}" , 
         "Total logged time: #{r['total_duration'].to_i.seconds_to_hhmm}",
         "Project time:"
        ] + 
        r['projects'].map do |p|
          "  #{p['name']}   #{p['total_duration'].to_i.seconds_to_hhmm}  last: #{Time.parse(p['last_started_at']).strftime('%a %d %b %Y %I:%M%p')} #{p['last_task']}"
        end
      end
            
      def run
        render get
      end
            
    end

  end
end