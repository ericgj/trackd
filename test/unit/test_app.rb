require File.join(File.dirname(__FILE__), '..', 'helper.rb')
require 'mocha'

describe 'start' do
  include Rack::Test::Methods
  
  def app
    Trackd::App
  end
    
  before do
    @id = 999
    project = mock(); log = mock()
    log.expects(:id).returns(@id)
    project.expects(:start_log).returns(log)
    Trackd::Project.expects(:first_or_create).returns(project)
    Trackd::Log.any_instance.stubs(:stop)
    post '/1/projects/test/logs'
  end
  
  it 'should redirect' do
    assert last_response.redirect?
  end
  
  it 'should redirect to new log route' do
    assert_equal "/1/logs/#{@id}", last_response['Location']
  end
  
end

describe 'stop' do
  include Rack::Test::Methods
  
  def app
    Trackd::App
  end
    
  before do
    @id = 999
    log = mock()
    log.expects(:stop)
    log.expects(:id).returns(@id)
    Trackd::Log.expects(:get).with(@id.to_s).returns(log)
    put "/1/logs/#{@id}"
  end
  
  it 'should redirect' do
    assert last_response.redirect?
  end
  
  it 'should redirect to log route' do
    assert_equal "/1/logs/#{@id}", last_response['Location']
  end
  
end
