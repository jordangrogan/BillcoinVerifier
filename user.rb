# This class will represent a user in the Billcoin blockchain
# The user will have a name and a number of Billcoins associated with them
class User
  attr_accessor :@numCoins, :@name
  def initialize name
    @name = name
    @numCoins = 0
  end

  def setCoins num
    @numCoins = num
  end

  def addCoins num
    @numCoins+=num;
  end
end