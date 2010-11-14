require 'net/http'
require 'uri'
require 'json/pure'

module Track
  module CLI

    class Command
      
      class << self
        attr_reader :base_uri
        def base_uri=(uri)
          @base_uri = URI.parse(uri)
        end
        
        attr_reader :uri_path
        def uri_path=(pattern)
          @uri_path = pattern
        end
        
        attr_reader :report
        def report_as(&blk)
          @report = blk
        end
      end
      
      def base_uri
        self.class.base_uri
      end
      
      def uri_path
        return unless self.class.uri_path
        self.class.uri_path.gsub(/:(\w+)/) do |s|
          @params[$1] || $1
        end
      end
      
      def uri
        return unless base_uri && uri_path
        URI.join( base_uri.to_s, uri_path )
      end
      
      
      def initialize(args)
        @argv = args
        @params = {}
        parse!
      end
      
      #subclass
      def parse!
        @argv.each_with_index do |arg, i|
          @params[i.to_s] = arg
        end
      end
      
      #subclass
      def run
      end
      
      def handle_response(resp)
        case resp
        when Net::HTTPSuccess
          #puts resp.body
          report JSON.parse(resp.body)
        when Net::HTTPRedirection
          handle_response get(resp['location'])
        else
          #TODO
        end
      end
      
      def report(body)
        lines = self.class.report.call(body)
        lines = [lines] unless Array === lines
        lines.each {|line| puts line}
      end
     
    protected
    
      def get(path=nil)
        path ||= uri_path
        Net::HTTP.start(base_uri.host, base_uri.port) do |http|
          http.get(path)
        end
      end
      
      def post(path=nil, data = {})
        path ||= uri_path
        Net::HTTP.post_form(URI.join(base_uri.to_s, path), data)
      end
      
      def put(path=nil)
        path ||= uri_path
        req = Net::HTTP::Put.new(path)
        Net::HTTP.start(base_uri.host, base_uri.port) do |http|
          http.request(req)
        end
      end
      
      def delete(path=nil)
        path ||= uri_path
        req = Net::HTTP::Delete.new(path)
        Net::HTTP.start(base_uri.host, base_uri.port) do |http|
          http.request(req)
        end
      end
      
    end
 
  end
end
