require File.join(File.dirname(__FILE__), '..', 'helper.rb')
require File.join(File.dirname(__FILE__), '..', 'env_helper.rb')

describe 'Trackd::Log duration'

  it 'should initially be zero'
  
  it 'should be close to Time.now - started_at when started'
  
  it 'should be stopped_at - started_at when stopped'
  
  it 'should be close to Time.now - started_at + adjusted when started with adjusted time'
  
  it 'should be stopped_at - started_at + adjusted when stopped with adjusted time'
  
end
