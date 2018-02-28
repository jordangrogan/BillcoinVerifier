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

  def test_hash
    assert_equal @v.hash("0|0|SYSTEM>Henry(100)|1518892051.737141000"), "1c12"
    assert_equal @v.hash("1|1c12|SYSTEM>George(100)|1518892051.740967000"), "abb2"
  end

  # TODO: Should probably sprout out the verify_hash method so that there's a interpolate_string method, maybe more, then this test wouldn't be so long
  def test_verify_hash
    block0 = Minitest::Mock::new("block0")
    def block0.number; 0; end
    def block0.hash_prev_block; "0"; end
    def block0.transactions; "SYSTEM>Henry(100)"; end
    def block0.timestamp; "1518892051.737141000"; end
    def block0.hash_this_block; "1c12"; end
    block1 = Minitest::Mock::new("block1")
    def block1.number; 1; end
    def block1.hash_prev_block; "1c12"; end
    def block1.transactions; "SYSTEM>George(100)"; end
    def block1.timestamp; "1518892051.740967000"; end
    def block1.hash_this_block; "abb2"; end
    block2 = Minitest::Mock::new("block2")
    def block2.number; 2; end
    def block2.hash_prev_block; "abb2"; end
    def block2.transactions; "George>Amina(16):Henry>James(4):Henry>Cyrus(17):Henry>Kublai(4):George>Rana(1):SYSTEM>Wu(100)"; end
    def block2.timestamp; "1518892051.753197000"; end
    def block2.hash_this_block; "c72d"; end
    block3 = Minitest::Mock::new("block3")
    def block3.number; 3; end
    def block3.hash_prev_block; "c72d"; end
    def block3.transactions; "SYSTEM>Henry(100)"; end
    def block3.timestamp; "1518892051.764563000"; end
    def block3.hash_this_block; "7419"; end
    @v.blocks = [block0, block1, block2, block3]
    assert @v.verify_hash
  end

end
