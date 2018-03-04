require_relative "User"
# This class will hold the master list of users on the Billcoin blockchain
class UserList
  def initialize
    @user_list = []
    @user_cache = {} # create new hashmap to hold name cache
  end

  def add_user user, start
    new_user = User.new(user,start)
    @user_list << new_user
    @user_cache[user] = @user_list.size - 1 # the value is the index in the @user_list array
    new_user
  end

  # This method will return whether a use exists in the system
  # Uses user cache to get a constant lookup time
  def user_exist? username
    if @user_cache.has_key? username
      return true
    end
    return false
  end

  def find_user username
    @user_list[@user_cache[username]]
  end

  def output_transaction_data
    @user_list.each do |user|
      puts "#{user.name}: #{user.num_coins} billcoins"
    end
  end

end
