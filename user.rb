# This class will represent a user in the Billcoin blockchain
# The user will have a name and a number of Billcoins associated with them
class User

  attr_accessor :num_coins, :name

  def initialize name, start_amt
    @name = name
    @num_coins = start_amt
  end

  def negative_balance?
    if num_coins < 0
      true
    else
      false
    end
  end

end
