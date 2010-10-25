module Trackd
  class Project
    include DataMapper::Resource
    
    property :id, Serial
    property :name, String
    
    has n, :logs
    
    def start_log(task = nil, dur = 0)
      log = Log.new(:task => task, :adjusted => dur)
      self.logs << log
      log.start; log
    end
    
      
  end
end