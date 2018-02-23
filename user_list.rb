require_relative "User"
# This class will hold the master list of users on the Billcoin blockchain
class UserList
  def initialize
    @userList = []
  end

  def addUser user
    @userList.push(user)
  end

  # This method will return whether a use exists in the system
  def userExist? username
    @userList.each do |user|
      if user.name.eql? (username)
        return true
      end
    end
    return false
  end
end