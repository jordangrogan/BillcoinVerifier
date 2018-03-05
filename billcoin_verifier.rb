require_relative "block"
require_relative "user_list"

class BillcoinVerifier

  attr_accessor :blocks, :user_list

  def initialize
    @user_list = UserList::new
    @blocks = []
  end

  def verify(input_file)

    File.open(input_file, "r").each_line do |line|
      block_split = line.chomp.split("|")
      block = Block::new(block_split[0], block_split[1], block_split[2], block_split[3], block_split[4])
      @blocks << block
    end

    if !verify_transaction_data
      puts "BLOCKCHAIN INVALID"
      return
    end

    if !verify_timestamp
      puts "BLOCKCHAIN INVALID"
      return
    end

    if !verify_line_order
      puts "BLOCKCHAIN INVALID"
      return
    end

    if !verify_hash
      puts "BLOCKCHAIN INVALID"
      return
    end

    @user_list.output_transaction_data

  end

  # Generates users & their transaction data
  # Verifies that at each block, the users don't have a negative balance
  def verify_transaction_data

    @blocks.each do |block|

      block_transactions = block.transactions
      block_users = []

      # Loop through each transaction
      block_transactions.split(":").each do |transaction|

        from = t_from(transaction)
        to = t_to(transaction)
        amt = t_amt(transaction).to_i

        # If it's from the system, ignore adding SYSTEM to the @user_list or decreasing coins
        if(from != "SYSTEM")

          if !@user_list.user_exist?(from)
            from = @user_list.add_user(from, 0)
          else
            from = @user_list.find_user(from)
          end

          from.num_coins -= amt

          block_users << from

        end

        if !@user_list.user_exist?(to)
          to = @user_list.add_user(to, 0)
        else
          to = @user_list.find_user(to)
        end

        to.num_coins += amt

        block_users << to

      end

      # Check the users in this block for a negative balance
      block_users.each do |user|

        if user.negative_balance?
          puts "Line #{block.number}: Invalid block, address #{user.name} has #{user.num_coins} billcoins!"
          return false
        end

      end

    end

  end

  # This function takes a transaction string in the format of USER1>USER2(NUMBILLCOINS)
  # This function will return the name of USER1, the USER sending billcoins
  def t_from t_string
    first = t_string[/[A-Z]*[a-z]*(>)/]
    first.chop
  end

  # This function takes a transaction string in the format of USER1>USER2(NUMBILLCOINS)
  # This function will return the name of USER2, the USER receiving billcoins
  def t_to t_string
    second = t_string[/(>)[A-Z]*[a-z]*/]
    second[1,second.length-1]
  end

  # This function takes a transaction string in the format of USER1>USER2(NUMBILLCOINS)
  # This function will return the amount of billcoins transfered in this transaction
  def t_amt t_string
    amt = t_string[/[\(][0-9]*[\)]/]
    amt[1,amt.length-2]
  end

  # method to verify block numbers are in order
  def verify_line_order
    i = 0
    @blocks.each do |block|
      line_num = block.number
      if line_num.to_i != i
        puts "Line #{i}: Invalid block number #{line_num}, should be #{i}"
        return false
      end
      i += 1
    end
    true
  end

  def verify_hash
    hashed_string = "0"
    @blocks.each do |block|

      # Check previous hash
      if hashed_string != block.hash_prev_block
        puts "Line #{block.number}: Previous hash was #{block.hash_prev_block}, should be #{hashed_string}"
        return false
      end

      # Check this block's hash
      interpolated_string = "#{block.number}|#{block.hash_prev_block}|#{block.transactions}|#{block.timestamp}"
      hashed_string = hash(interpolated_string)
      if block.hash_this_block != hashed_string
        puts "Line #{block.number}: String '#{interpolated_string}' hash set to #{block.hash_this_block}, should be #{hashed_string}"
        return false
      end

    end
    true
  end

  def hash string
    val = 0
    utf_8_characters = string.unpack('U*')
    utf_8_characters.each do |x|
      val += (x ** 2000) * ((x + 2) ** 21) - ((x + 5) ** 3)
    end
    val %= 65536
    val.to_s(16)
  end

  def verify_timestamp
    last_block_seconds = -1
    last_block_nanoseconds = -1
    @blocks.each do |block|

      this_block_seconds = get_timestamp_seconds(block.timestamp).to_i
      this_block_nanoseconds = get_timestamp_nanoseconds(block.timestamp).to_i

      # If last block's seconds > this block's seconds, return false
      # Or, if they equal, then check to see if last block's NANOseconds > this block's NANOseconds, if so, return false
      if (last_block_seconds > this_block_seconds) || ((last_block_seconds == this_block_seconds) && (last_block_nanoseconds >= this_block_nanoseconds))
        puts "Line #{block.number}: Previous timestamp #{last_block_seconds}.#{last_block_nanoseconds} >= new timestamp #{block.timestamp}"
        return false
      end

      last_block_seconds = this_block_seconds
      last_block_nanoseconds = this_block_nanoseconds

    end
    true
  end

  def get_timestamp_seconds timestamp
    timestamp[/[0-9]*(\.)/].chop
  end

  def get_timestamp_nanoseconds timestamp
    nanoseconds = timestamp[/(\.)[0-9]*/]
    nanoseconds = nanoseconds[1, nanoseconds.length-1]
    nanoseconds
  end

end
