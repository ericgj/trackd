
module Trackd
  class App < Sinatra::Base
    
    PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__),'..', '..'))
    SINATRA_ROOT = File.expand_path(File.dirname(__FILE__))
    
    def self.logger; @logger ||= DataMapper.logger; end
    
    def self.load_models
      Dir[File.join(SINATRA_ROOT,'models','**','*.rb')].each do |f|
        require f
      end      
    end

    def self.stop_current(t = Time.now)
      Log.transaction do
        Log.started.each {|log| log.stop(t) }
      end
    end
    
    def self.at_exit
      logger.info "Trackd::App shutdown started"
      logger.info "Stopping started logs..."
      stop_current
      Server.down!
    end
    
    #---- Dbase config
    
    configure :production do
      db = "sqlite3://#{PROJECT_ROOT}/db/production.sqlite3"
      DataMapper::Logger.new(File.join(PROJECT_ROOT,'log','production.log'), :debug)
      DataMapper.setup(:default, db)
    end
    
    configure :test do
      db = "sqlite3::memory:"
      DataMapper::Logger.new(File.join(PROJECT_ROOT,'log','test.log'), :debug)
      DataMapper.setup(:default, db)
    end
    
    configure :development do
      db = "sqlite3://#{PROJECT_ROOT}/db/development.sqlite3"
      DataMapper::Logger.new(File.join(PROJECT_ROOT,'log','development.log'), :debug)
      DataMapper.setup(:default, db)
    end

    configure :production, :test, :development do
      load_models
      DataMapper.auto_migrate! \
        if DataMapper.repository(:default).adapter.options['path'] == ':memory:' 
        #  unless DataMapper.storage_exists?
      DataMapper.finalize
      logger.info "Database connection established"
    end

    configure do 
      logger.info "Trackd::App is running"
      Server.up!
    end
    
    #---- REST paths
    
    get '/' do
      sum = Log.total_duration
      "Trackd: tracking #{sum ? sum.seconds_to_hhmm : 'zero'} hours for #{Project.count} projects"
    end
    
    #---- API v1
    
    # status
    get '/1/status' do
      { :server_uptime => Server.uptime,
        :total_duration => Log.total_duration,
        :projects => Queries.project_status.map
      }.to_json
    end
    
    # cat
    get '/1/logs' do
      logs = Log.all(:order => [:started_at.desc])
      logs.map.to_json
    end
    
    get '/1/logs/:id' do |id|
      log = Log.get(id)      
      log.to_json
    end
    
    # stop
    put '/1/logs/:id' do |id|
      t = Time.now
      log = Log.get(id)
      log.stop
      redirect "/1/logs/#{log.id}"
    end
    
    # not used?
    get '/1/projects' do
      projs = Project.all(:order => [:name])
      projs.map.to_json
    end
    
    # start / restart
    post '/1/projects/:name/logs' do |name|
      t = Time.now
      stop_current
      dur = (params[:time] || 0).to_i
      task = params[:task]
      p = Project.first_or_create(:name => name)
      log = p.start_log(task, dur)
      redirect "/1/logs/#{log.id}"
    end

    # add / sub
    put '/1/projects/:name/logs' do |name|
      t = Time.now
      dur = (params[:time] || 0).to_i
      task = params[:task]
      p = Project.first_or_create(:name => name)
      log = p.add_log(task, dur)
      redirect "/1/logs/#{log.id}"
    end
       
   private
   
    def stop_current(t = Time.now); self.class.stop_current(t); end
       
  end
end