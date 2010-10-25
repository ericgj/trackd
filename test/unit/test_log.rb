require File.join(File.dirname(__FILE__), '..', 'helper.rb')

describe 'Trackd::Log duration' do
  include TransactionHelper
  
  before do
    @_trans = transaction_begin
    @subject = Trackd::Log.new
  end
  
  after do
    transaction_rollback @_trans
  end
  
  it 'should initially be zero' do
    @subject.duration.must_equal 0
  end
  
  it 'should be close to Time.now - started_at when started' do
    @subject.start(Time.now - 300)
    assert_in_delta 300, @subject.duration, 0.1
  end
  
  it 'should be stopped_at - started_at when stopped' do
    @subject.start(Time.now - 300)
    @subject.stop
    @subject.duration.must_equal((@subject.stopped_at - @subject.started_at).to_i)
  end
  
  it 'should be close to Time.now - started_at + adjusted when started with adjusted time' do
    @subject.start(Time.now - 300)
    @subject.adjusted = 500
    assert_in_delta 800, @subject.duration, 0.1
  end
  
  it 'should be stopped_at - started_at + adjusted when stopped with adjusted time' do
    @subject.start(Time.now - 300)
    @subject.adjusted = 500
    @subject.stop
    @subject.duration.must_equal((@subject.stopped_at - @subject.started_at + @subject.adjusted).to_i)
  end
  
end
