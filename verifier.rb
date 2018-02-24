# method to verify block numbers are in order
def verifyLineOrder lineNums
  oldVal = -1
  lineNums.each do |lineInt|
    if lineInt.to_i < oldVal
      return false
    end
    oldVal = lineInt.to_i
  end
  return true
end

def gatherTransactionData data
  @transactionData.each do |splitData|
    count = 1
    splitData.each do |splitLine|

      if(count == 3)
        # SHOULD LOOP HERE
        #puts stripstring
        loop do
          #puts splitLine
          stripstring = splitLine[@transactionRegex]
          puts stripstring
          unless stripstring.eql? nil
            splitLine = splitLine[stripstring.length-1,splitLine.length]
          end
          break if stripstring.eql? nil
        end

      end
      count +=1;
    end
  end
end
# This function takes a transaction string in the format of USER1>USER2(NUMBILLCOINS)
# This function will return the name of USER1, the USER sending billcoins
def tGetFirst t_string
  first = t_string[/[A-Z]*[a-z]*(>)/]
  return first.chop
end
# This function takes a transaction string in the format of USER1>USER2(NUMBILLCOINS)
# This function will return the name of USER2, the USER receiving billcoins
def tGetSecond t_string
  second = t_string[/(>)[A-Z]*[a-z]*/]
  return second[1,second.length]
end
# This function takes a transaction string in the format of USER1>USER2(NUMBILLCOINS)
# This function will return the amount of billcoins transfered in this transaction
def tGetAmt t_string
  amt = t_string[/[\(][0-9]*[\)]/]
  return amt[1,amt.length-2]
end

class Verifier
  # var to keep track of the line numbers for each block
  @lineNums = []
  @transactionData = []
  @transactionRegex = /[A-Z]*[a-z]*(>)[A-Z]*[a-z]*[\(][0-9]*[\)][\:]*/
  # main loop going through each line of file
  File.open("sample.txt").each do |line|
    currLine =  line.to_s
    @transactionData.push(currLine.split("|"))
    @lineNums.push(currLine[0])
  end

  # This currently separates the actual transaction data portion of the line
  # so that the totals for each person can be calculated
  # Once working this will be moved to a function
  gatherTransactionData @transactionData

  if verifyLineOrder(@lineNums)
    puts "block line check passed"
  else
    puts "block line check failed"
  end
end


