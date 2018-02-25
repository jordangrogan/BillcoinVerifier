require_relative "billcoin_verifier"

raise "Enter input file" unless ARGV.count == 1
input_file = ARGV[0]

verifier = BillcoinVerifier::new
verifier.open_file(input_file)
verifier.run_verifications
