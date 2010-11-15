module Trackd
  class Project
    include DataMapper::Resource
    
    property :id, Serial
    property :name, String
    
    has n, :logs
    
    def add_log(task = nil, dur = 0)
      t = Time.now
      log = Log.new(:task => task, :adjusted => dur, :started_at => t, :stopped_at => t)
      self.logs << log
      log.save; log
    end

    def sub_log(task = nil, dur = 0)
      add_log(task, -1 * dur)
    end
    
    def start_log(task = nil, dur = 0)
      log = Log.new(:task => task, :adjusted => dur)
      self.logs << log
      log.start; log
    end
          
    def to_json(*args)
      attributes.merge({:logs => logs.map}).to_json(*args)
    end
    
  end
end