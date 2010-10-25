module Trackd
  class Log
    include DataMapper::Resource
    
    property :id, Serial
    property :task, String
    property :adjusted, Integer, :default => 0
    property :started_at, Time
    property :stopped_at, Time
    property :project_id, Integer
    
    belongs_to :project
    
    def self.started
      all :started_at.not => nil, :stopped_at => nil
    end
    
    def self.stopped
      all :stopped_at.not => nil
    end
    
    def self.total_time
      repository(:default).adapter.select(
        'SELECT SUM(stopped_at - started_at + adjusted) FROM trackd_logs' 
      )[0]
    end
    
    def duration
      t = Time.now
      ((self.stopped_at || t) - (self.started_at || t) + self.adjusted).to_i
    end
        
    def start(t = Time.now)
      self.started_at = t; save
      self
    end
    
    def stop(t = Time.now)
      self.stopped_at = t; save
      self
    end
    
  end
end