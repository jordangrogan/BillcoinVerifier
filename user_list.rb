require_relative "User"
# This class will hold the master list of users on the Billcoin blockchain
class UserList
  def initialize
    @user_list = []
    @user_cache = {} # create new hashmap to hold name cache
  end

  def addUser user
    @user_list.push(user)
    @user_cache[user] = 1 # just adding a simple 1 to signify existence
  end

  # This method will return whether a use exists in the system
  # Uses user cache to get a constant lookup time
  def userExist? username
    if @user_cache.has_key? username
      return true
    end
    return false
  end

end