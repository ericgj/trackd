
module Trackd
  class App < Sinatra::Base

    ENV['APP_PATH'] = File.expand_path(File.dirname(__FILE__))
    
    #---- Dbase config
    
    configure :production do
      db = "sqlite3:///#{ENV['APP_PATH']}/db/production.sqlite3"
      DataMapper::Logger.new(STDOUT, :debug)    #TODO to file
      DataMapper.setup(:default, db)
    end
    
    configure :test do
      db = "sqlite3::memory:"
      DataMapper::Logger.new(STDOUT, :debug)
      DataMapper.setup(:default, db)
    end
    
    configure :development do
      db = "sqlite3:///#{ENV['APP_PATH']}/db/development.sqlite3"
      DataMapper::Logger.new(STDOUT, :debug)
      DataMapper.setup(:default, db)
    end

    configure :production, :test, :development do
      load_models
      DataMapper.auto_migrate! unless DataMapper.storage_exists?
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
      logs = Log.all.descending_by_started_at 
      logs.to_json    # not sure this will work
    end

    
    get '/1/logs/:id' do |id|
      content_type mime_type(:json), :charset => 'utf-8'
      log = Log.find(id)      
      log.to_json   # defined in model ?
    end
    
    # stop
    put '/1/logs/:id' do |id|
      t = Time.now
      log = Log.find(id)
      log.stopped_at = t
      log.save
      redirect "/1/logs/#{log.id}"
    end
    
    
    # start / restart
    post '/1/projects/:name/logs' do |name|
      t = Time.now
      stop_current
      dur = (params[:time] || 0).to_i
      task = params[:task]
      p = Project.create_or_new(:name => name)
      log = Log.new(:task => task, 
                    :adjusted => dur,
                    :project => p)
      log.start(t)
      log.save
      redirect "/1/logs/#{log.id}"
    end
    
    
   protected
   
    def load_models
      Dir[File.join(ENV['APP_PATH'],'models')].each do |f|
        require f
      end      
    end
    
    def stop_current(t = Time.now)
      Log.current.each {|log| log.stop(t) }
    end
    
  end
end