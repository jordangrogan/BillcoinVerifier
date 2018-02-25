class Block

  attr_accessor :number, :hash_prev_block, :transactions, :timestamp, :hash_this_block

  def initialize number, hash_prev_block, transactions, timestamp, hash_this_block
    @number = number
    @hash_prev_block = hash_prev_block
    @transactions = transactions
    @timestamp = timestamp
    @hash_this_block = hash_this_block
  end

end
