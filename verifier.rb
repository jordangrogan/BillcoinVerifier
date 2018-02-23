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


class Verifier
  # var to keep track of the line numbers for each block
  @lineNums = []
  @transactionData = []
  # main loop going through each line of file
  File.open("sample.txt").each do |line|
    currLine =  line.to_s
    @transactionData.push(currLine.split("|"))
    @lineNums.push(currLine[0])
  end

  # This currently separates the actual transaction data portion of the line
  # so that the totals for each person can be calculated 
  @transactionData.each do |splitData|
    count = 1
    splitData.each do |splitLine|
      if(count == 3)
        puts splitLine
      end
      count +=1;
    end
  end

  if verifyLineOrder(@lineNums)
    puts "block line check passed"
  else
    puts "block line check failed"
  end
end


