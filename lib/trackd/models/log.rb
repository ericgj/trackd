module Trackd
  class Log
    include DataMapper::Resource
    
    property :id, Serial
    property :task, String
    property :adjusted, Integer, :default => 0
    property :started_at, Time
    property :stopped_at, Time
    property :message, Text
    property :project_id, Integer
    
    belongs_to :project
    
    def self.started(opts = {})
      all opts.merge({:started_at.not => nil, :stopped_at => nil})
    end
    
    def self.stopped(opts = {})
      all opts.merge(:stopped_at.not => nil)
    end
    
    def self.total_duration
      repository(:default).adapter.select(
        %q{ SELECT SUM(t.dur) FROM 
              (SELECT (strftime('%s',stopped_at) - strftime('%s',started_at) + adjusted) AS dur FROM trackd_logs
              ) as t
          }
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
        
    def to_json(*args)
      attributes.merge(
        {:duration => duration, 
         :project => { :id => self.project_id, 
                       :name => project.name }
        }).to_json(*args)
    end
    
  end
end