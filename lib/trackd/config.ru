# TODO: config dbase & models here instead of within app
#       otherwise we don't have models loaded for at_exit block

require File.join(File.dirname(__FILE__),'..','trackd')
Trackd::App.run! :port => 2003

at_exit {
  DataMapper.logger.info "Stopping started logs..."
  t = Time.now
  Log.started.each do |log|
    log.stop t
  end
}

