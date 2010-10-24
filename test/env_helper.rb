# Manually initialize test environment
# for tests that do not run the Sinatra app

db = "sqlite3::memory:"
DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, db)

Dir[File.join(Trackd::App::SINATRA_ROOT,'models')].each do |f|
  require f
end      

DataMapper.auto_migrate! unless DataMapper.storage_exists?
DataMapper.finalize
