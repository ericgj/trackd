class Server
  include DataMapper::Resource

  property :id, Serial
  property :started_at, Time
  property :stopped_at, Time

  def self.record
    @rec ||= first_or_create
  end
  
  def self.up!
    record.started_at = Time.now
    record.stopped_at = nil
    record.save
  end
  
  def self.down!
    record.stopped_at = Time.now
    record.save
  end
  
  def self.started_at; @rec.started_at; end
  def self.stopped_at; @rec.stopped_at; end
  def self.uptime; @rec.uptime; end

  def uptime
    self.started_at ? Time.now - self.started_at : nil
  end
  
end
