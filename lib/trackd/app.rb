
module Remindrd
  class App < Sinatra::Base

    
    #---- Dbase config

    #---- REST paths
    
    get '/' do
      "Trackd server is running: tracking #{Projects.all.count} projects"
    end
    
    #---- API v1
    
    # cat
    get '/1/logs' do
      content_type mime_type(:json), :charset => 'utf-8'
      logs = Logs.all.descending_by_started_at 
      logs.to_json    # not sure this will work
    end

    
    get '/1/logs/:id' do |id|
      content_type mime_type(:json), :charset => 'utf-8'
      log = Logs.find(id)      
      log.to_json   # defined in model ?
    end
    
    # stop
    put '/1/logs/:id' do |id|
      t = Time.now
      log = Logs.find(id)
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
      p = Projects.create_or_new(:name => name)
      log = Logs.new(:task => task, 
                    :adjusted => dur,
                    :project => p)
      log.start(t)
      log.save
      redirect "/1/logs/#{log.id}"
    end
    
    
   protected
   
    def stop_current(t = Time.now)
      Logs.current.each {|log| log.stop(t) }
    end
    
  end
end