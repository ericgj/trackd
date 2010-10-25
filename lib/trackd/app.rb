
module Trackd
  class App < Sinatra::Base
    
    SINATRA_ROOT = File.expand_path(File.dirname(__FILE__))
    
    def self.load_models
      Dir[File.join(SINATRA_ROOT,'models','**','*.rb')].each do |f|
        require f
      end      
    end

    #---- Dbase config
    
    configure :production do
      db = "sqlite3:///#{SINATRA_ROOT}/db/production.sqlite3"
      DataMapper::Logger.new(STDOUT, :debug)    #TODO to file
      DataMapper.setup(:default, db)
    end
    
    configure :test do
      db = "sqlite3::memory:"
      DataMapper::Logger.new(STDOUT, :debug)
      DataMapper.setup(:default, db)
    end
    
    configure :development do
      db = "sqlite3:///#{SINATRA_ROOT}/db/development.sqlite3"
      DataMapper::Logger.new(STDOUT, :debug)
      DataMapper.setup(:default, db)
    end

    configure :production, :test, :development do
      load_models
      DataMapper.auto_migrate! #  unless DataMapper.repository(:default).storage_exists?('trackd_logs')
      DataMapper.finalize
    end

    #---- REST paths
    
    get '/' do
      "Trackd server is running: tracking #{Project.all.count} projects"
    end
    
    #---- API v1
    
    # cat
    get '/1/logs' do
      content_type mime_type(:json), :charset => 'utf-8'
      logs = Log.all(:order => [:started_at.desc])
      logs.to_json(:methods => [:project, :duration])
    end

    
    get '/1/logs/:id' do |id|
      content_type mime_type(:json), :charset => 'utf-8'
      log = Log.get(id)      
      log.to_json(:methods => [:project, :duration])
    end
    
    # stop
    put '/1/logs/:id' do |id|
      t = Time.now
      log = Log.get(id)
      log.stop
      redirect "/1/logs/#{log.id}"
    end
    
    
    # start / restart
    post '/1/projects/:name/logs' do |name|
      t = Time.now
      stop_current
      dur = (params[:time] || 0).to_i
      task = params[:task]
      p = Project.first_or_create(:name => name)
      log = p.add_log(task, dur)
      redirect "/1/logs/#{log.id}"
    end
    
       
   protected
   
    def stop_current(t = Time.now)
      Log.transaction do
        Log.started.each {|log| log.stop(t) }
      end
    end
    
  end
end