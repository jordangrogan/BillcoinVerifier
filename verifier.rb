def verifyLineOrder lineNums
  oldVal = -1
  lineNums.each do |lineInt|
    if lineInt.to_i < oldVal
      puts "false"
      return false
    end
  end
  puts "true"
  return true
end


class Verifier
  # var to keep track of the line numbers for each block
  @lineNums = []
  # main loop going through each line of file
  File.open("sample.txt").each do |line|
    currLine =  line.to_s
    @lineNums.push(currLine[0])
  end

  # method to verify block numbers are in order
  verifyLineOrder(@lineNums)
end


