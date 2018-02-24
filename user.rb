# This class will represent a user in the Billcoin blockchain
# The user will have a name and a number of Billcoins associated with them
class User
  attr_accessor :@numCoins, :@name
  def initialize name, start_amt
    @name = name
    @num_coins = start_amt
  end

  def setCoins num
    @num_coins = num
  end

  def addCoins num
    @num_coins += num;
  end

  def removeCoins num
    @num_coins -= num;
  end
end