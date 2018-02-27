require 'minitest/autorun'

require_relative 'billcoin_verifier'

class BillcoinVerifierTest < Minitest::Test

  def setup
    @v = BillcoinVerifier::new()
  end

  def test_verify_line_order_in_order
    block0 = Minitest::Mock::new("block0")
    def block0.number; 0; end
    block1 = Minitest::Mock::new("block1")
    def block1.number; 1; end
    block2 = Minitest::Mock::new("block2")
    def block2.number; 2; end
    block3 = Minitest::Mock::new("block3")
    def block3.number; 3; end
    @v.blocks = [block0, block1, block2, block3]
    assert @v.verify_line_order
  end

  def test_verify_line_order_out_of_order
    block0 = Minitest::Mock::new("block0")
    def block0.number; 0; end
    block1 = Minitest::Mock::new("block1")
    def block1.number; 1; end
    block2 = Minitest::Mock::new("block2")
    def block2.number; 3; end
    block3 = Minitest::Mock::new("block3")
    def block3.number; 2; end
    @v.blocks = [block0, block1, block2, block3]
    assert_output("Line 2: Invalid block number 3, should be 2\n") { @v.verify_line_order }
  end

end
