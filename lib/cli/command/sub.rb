module Track
  module CLI

    class Sub < Add
      self.uri_path = "/1/projects/:project/logs?task=:task&time=:time"
      
      report_as do |r| 
        "(#{r['id']}) #{r['project']['name']} - #{r['task']} subtracted #{(r['duration'].to_i * -1).seconds_to_hhmm}" 
      end
      
      def parse!
        super
        @params['time'] = -1 * @params['time'].to_i if @params['time']
      end
    end

  end
end