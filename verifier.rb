require 'flamegraph'
require_relative "billcoin_verifier"

raise "Enter input file" unless ARGV.count == 1
input_file = ARGV[0]

Flamegraph.generate('flamegraph.html') do

  verifier = BillcoinVerifier::new
  verifier.verify(input_file)

end
