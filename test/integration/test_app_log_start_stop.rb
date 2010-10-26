require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')
require File.join(File.dirname(__FILE__), '..', 'shared', 'server_runner_helper.rb')
require 'httparty'
require 'json/pure'

HOST = 'localhost'; PORT = '2003'

class TestClient
  include HTTParty
  base_uri "#{HOST}:#{PORT}"
end
  
describe 'start' do
  include ServerRunnerHelper
  
  before do
    @project = 'test'
    start_server
  end
  
  after { stop_server }
  
  it 'should return new log' do
    response = TestClient.post("/1/projects/#{@project}/logs")
    response.body.wont_be_nil
    response.body.wont_be_empty
    log = JSON.parse(response.body)
    puts log.inspect
    log['project']['name'].must_equal @project
  end
  
end

describe 'start and stop' do
  include ServerRunnerHelper
  
  before do
    @project = 'test'
    start_server
    response = TestClient.post("/1/projects/#{@project}/logs")
    log = JSON.parse(response.body)
    @id = log['id']
  end
  
  after { stop_server }
  
  it 'should return a duration ~2 secs' do
    sleep 2
    response = TestClient.put("/1/logs/#{@id}")
    log = JSON.parse(response.body)
    puts log.inspect
    log['duration'].to_i.must_be_within_delta 2, 1
  end
  
end
