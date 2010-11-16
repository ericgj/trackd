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
         if r['current_log']
           "Current task: #{r['current_log']['project']['name']} - #{r['current_log']['task']}  #{r['current_log']['duration'].to_i.seconds_to_hhmm}"
         else
           "Current task: -------"
         end ,
         "Project time and last task:"
        ] + 
        r['projects'].map do |p|
          t = Time.parse(p['last_started_at'])
          "  #{p['name']}  #{p['total_duration'].to_i.seconds_to_hhmm}  #{t.strftime('%a %d %b %Y %I:%M%p') if t}  #{p['last_task']}"
        end
      end
            
      def run
        render get
      end
            
    end

  end
end