module TransactionHelper

  def transaction_begin(repos = :default)
    tr = DataMapper::Transaction.new(DataMapper.repository(repos))
    tr.begin
    DataMapper.repository(repos).adapter.push_transaction(tr)
    tr
  end
  
  def transaction_rollback(tr, repos = :default)
    DataMapper.repository(repos).adapter.pop_transaction
    tr.rollback
    tr = nil
  end
  
  
end