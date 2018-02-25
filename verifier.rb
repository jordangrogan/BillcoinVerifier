require_relative "block"
require_relative "user_list"

class Verifier

  @user_list = UserList::new

  def initialize(input_file)
    @blocks = []
    File.open(input_file, "r").each_line do |line|
      block_split = line.chomp.split("|")
      block = Block::new(block_split[0], block_split[1], block_split[2], block_split[3], block_split[4])
      @blocks << block
    end

    gather_transaction_data

    if !verify_line_order
      puts "BLOCKCHAIN INVALID"
    end

  end

  # This currently separates the actual transaction data portion of the line
  # so that the totals for each person can be calculated
  def gather_transaction_data

    @blocks.each do |block|

      splitLine = block.transactions

      loop do
        stripstring = splitLine[/[A-Z]*[a-z]*(>)[A-Z]*[a-z]*[\(][0-9]*[\)][\:]*/]

        unless stripstring.eql? nil
          puts " #{t_from(stripstring)} is giving #{t_to(stripstring)} #{t_amt(stripstring)} billcoins "
          # ready to start populating here
          splitLine = splitLine[stripstring.length-1,splitLine.length]
        end

        break if stripstring.eql? nil
      end

    end

  end

  # This function takes a transaction string in the format of USER1>USER2(NUMBILLCOINS)
  # This function will return the name of USER1, the USER sending billcoins
  def t_from t_string
    first = t_string[/[A-Z]*[a-z]*(>)/]
    return first.chop
  end
  # This function takes a transaction string in the format of USER1>USER2(NUMBILLCOINS)
  # This function will return the name of USER2, the USER receiving billcoins
  def t_to t_string
    second = t_string[/(>)[A-Z]*[a-z]*/]
    return second[1,second.length]
  end
  # This function takes a transaction string in the format of USER1>USER2(NUMBILLCOINS)
  # This function will return the amount of billcoins transfered in this transaction
  def t_amt t_string
    amt = t_string[/[\(][0-9]*[\)]/]
    return amt[1,amt.length-2]
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

end

raise "Enter input file" unless ARGV.count == 1
input_file = ARGV[0]

Verifier::new(input_file)
