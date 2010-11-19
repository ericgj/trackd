module Track
  module CLI

    class Ping < Command
      
      self.uri_path = "/"
      
      def run
        puts get.body 
      end
            
    end

  end
end