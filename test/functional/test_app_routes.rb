require File.join(File.dirname(__FILE__), '..', 'helper.rb')

describe 'routes' do
  include Rack::Test::Methods
  include TransactionHelper
  
  def app
    Trackd::App
  end
  
  def routes
    {:get => %w{/ /1/logs /1/logs/1} }
  end
  
  before { @_trans = transaction_begin }
  after { transaction_rollback @_trans }
  
  it 'should respond to get routes' do
    routes[:get].each do |route|
      get route
      assert last_response.ok?
    end
  end
  
end