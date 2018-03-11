require_relative "User"

# This class will hold the master list of users on the Billcoin blockchain
class UserList
  def initialize
    @user_list = {}
  end

  def add_user user, start
    new_user = User.new(user,start)
    @user_list[user] = new_user
    new_user
  end

  # This method will return whether a use exists in the system
  # Uses user cache to get a constant lookup time
  def user_exist? username
    if @user_list.has_key? username
      return true
    end
    false
  end

  def find_user username
    @user_list[username]
  end

  def output_transaction_data
    @user_list.each do |key, user|
      puts "#{user.name}: #{user.num_coins} billcoins"
    end
  end

end
