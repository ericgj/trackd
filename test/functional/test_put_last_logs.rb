require 'json/pure'
require File.join(File.dirname(__FILE__), '..', 'helper.rb')

# just some dummy data so it's not empty...
# note all logs are stopped
def make_test_seeds
  Sham.reset
  t = Time.now
  p = Project.make
  Log.make :started_at => t - 60*60*24, 
           :stopped_at => t - 60*60*12,
           :project => p
  Log.make :started_at => t - 2*60*60*24, 
           :stopped_at => t - 2*60*60*23, 
           :adjusted => 5*60,
           :project => p
  Log.make :started_at => t - 3*60*60*24,
           :stopped_at => t - 3*60*60*18,
           :adjusted_start => -30*60
end

describe 'PUT /1/last/logs with :time, no task in process' do

  it 'should return log entity with stopped_at shifted by :time seconds' do
  end

end

describe 'PUT /1/last/logs with :time, task in process' do
  include TransactionHelper
  
  before do
    @_trans = transaction_begin
    @route = '/1/last/logs'
    @params = { :time => 15*60 }
    @original = { :started_at => Time.now - 30*60 }
                
    make_test_seeds
    Log.make(@original)
    
    put @route, :time => @params[:time]
  end
  
  after { transaction_rollback @_trans }
  
  it 'should return log entity with started_at shifted by negative :time seconds' do
    log = JSON.parse(last_response.body)
    assert_eql log.started_at, @original[:started_at] - @params[:time]
  end
  
  it 'should return log entity with adjusted equal to :time seconds' do
    log = JSON.parse(last_response.body)
    assert_eql log.adjusted, @params[:time]
  end
  
end


describe 'PUT /1/last/logs with :time, task specified' do


end