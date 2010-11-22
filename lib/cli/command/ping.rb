module Track
  module CLI

    class Ping < Command
      
      self.uri_path = "/"
      
      def run
        resp = get.body 
        puts "Server found, response:\n" + resp
      end
            
    end

  end
end