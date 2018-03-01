require 'minitest/autorun'

require_relative 'billcoin_verifier'

class BillcoinVerifierTest < Minitest::Test

  def setup
    @v = BillcoinVerifier::new()
  end

  # TODO: UNIT TEST FOR gather_transaction_data

  # UNIT TEST FOR t_from
  # A string in the format "USER1>USER2(###)" returns "USER1"
  def test_t_from
    assert_equal @v.t_from("Ross>Monica(100)"), "Ross"
  end

  # UNIT TEST FOR t_to
  # A string in the format "USER1>USER2(###)" returns "USER2"
  def test_t_to
    assert_equal @v.t_to("Chandler>Phoebe(100)"), "Phoebe"
  end

  # UNIT TEST FOR t_amt
  # A string in the format "USER1>USER2(###)" returns "###"
  def test_t_amt
    assert_equal @v.t_amt("Rachel>Joey(100)"), "100"
  end

  # UNIT TESTS FOR verify_line_order
  # Blocks in order     --> returns true
  # Blocks out of order --> returns false & outputs issue

  # Doubles bBocks & verifies that the blocks are in order
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

  # Doubles Blocks & puts them out of order to make sure that the
  # correct string is outputted & returns false
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
    refute @v.verify_line_order
  end

  # UNIT TEST FOR hash
  # This test tests two strings to make sure the correct hash is returned
  def test_hash
    assert_equal @v.hash("0|0|SYSTEM>Henry(100)|1518892051.737141000"), "1c12"
    assert_equal @v.hash("1|1c12|SYSTEM>George(100)|1518892051.740967000"), "abb2"
  end

  # UNIT TESTS FOR verify_hash
  # On success --> returns true
  # On failure --> outputs issue & returns false

  # This uses the first 4 blocks from sample.txt, which we know is correct
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

  # This tests when the previous hash is bad (returns false & outputs issue)
  def test_verify_hash_prev_hash_bad
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
    def block2.hash_prev_block; "abb3"; end # BAD!
    def block2.transactions; "George>Amina(16):Henry>James(4):Henry>Cyrus(17):Henry>Kublai(4):George>Rana(1):SYSTEM>Wu(100)"; end
    def block2.timestamp; "1518892051.753197000"; end
    def block2.hash_this_block; "c72d"; end
    @v.blocks = [block0, block1, block2]
    assert_output("Line 2: Previous hash was abb3, should be abb2\n") { @v.verify_hash }
    refute @v.verify_hash
  end

  # This tests when the current block's hash is bad (returns false & outputs issue)
  def test_verify_hash_this_hash_bad
    block0 = Minitest::Mock::new("block0")
    def block0.number; 0; end
    def block0.hash_prev_block; "0"; end
    def block0.transactions; "SYSTEM>Henry(100)"; end
    def block0.timestamp; "1518892051.737141000"; end
    def block0.hash_this_block; "1c13"; end # BAD!
    @v.blocks = [block0]
    assert_output("Line 0: String '0|0|SYSTEM>Henry(100)|1518892051.737141000' hash set to 1c13, should be 1c12\n") { @v.verify_hash }
    refute @v.verify_hash
  end

  # TODO: UNIT TESTS for verify_timestamp
  # On success --> returns true
  # On failure --> outputs issue & returns false

  # This uses the first 4 blocks from sample.txt, which we know is correct
  def test_verify_timestamp
    block0 = Minitest::Mock::new("block0")
    def block0.timestamp; "1518892051.737141000"; end
    block1 = Minitest::Mock::new("block1")
    def block1.timestamp; "1518892051.740967000"; end
    block2 = Minitest::Mock::new("block2")
    def block2.timestamp; "1518892051.753197000"; end
    block3 = Minitest::Mock::new("block3")
    def block3.timestamp; "1518892051.764563000"; end
    @v.blocks = [block0, block1, block2, block3]
    assert @v.verify_timestamp
  end

  # This ensures return false and issue is outputted when the seconds of
  # a previous block are greater than the seconds of the current block
  def test_verify_timestamp_prev_block_seconds_greater
    block0 = Minitest::Mock::new("block0")
    def block0.number; 0; end
    def block0.timestamp; "1518892051.737141000"; end
    block1 = Minitest::Mock::new("block1")
    def block1.number; 1; end
    def block1.timestamp; "1518892051.740967000"; end
    block2 = Minitest::Mock::new("block2")
    def block2.number; 2; end
    def block2.timestamp; "1518892051.753197000"; end
    block3 = Minitest::Mock::new("block3")
    def block3.number; 3; end
    def block3.timestamp; "1518892050.764563000"; end # BAD!
    @v.blocks = [block0, block1, block2, block3]
    assert_output("Line 3: Previous timestamp 1518892051.753197000 >= new timestamp 1518892050.764563000\n") { @v.verify_timestamp }
    refute @v.verify_timestamp
  end

  # This ensures return false and issue is outputted when the seconds of
  # a previous block are equal to the seconds of the current block, but
  # the nanoseconds of the previous block are greater
  def test_verify_timestamp_prev_block_seconds_equal_nanoseconds_greater
    block0 = Minitest::Mock::new("block0")
    def block0.number; 0; end
    def block0.timestamp; "1518892051.737141000"; end
    block1 = Minitest::Mock::new("block1")
    def block1.number; 1; end
    def block1.timestamp; "1518892051.740967000"; end
    block2 = Minitest::Mock::new("block2")
    def block2.number; 2; end
    def block2.timestamp; "1518892051.753197000"; end
    block3 = Minitest::Mock::new("block3")
    def block3.number; 3; end
    def block3.timestamp; "1518892051.752000000"; end # BAD!
    @v.blocks = [block0, block1, block2, block3]
    assert_output("Line 3: Previous timestamp 1518892051.753197000 >= new timestamp 1518892051.752000000\n") { @v.verify_timestamp }
    refute @v.verify_timestamp
  end

  # UNIT TEST FOR METHOD get_timestamp_seconds
  # The string "123.456" returns "123"
  def test_get_timestamp_seconds
    assert_equal @v.get_timestamp_seconds("1518892051.737141000"), "1518892051"
  end

  # UNIT TEST FOR METHOD get_timestamp_nanoseconds
  # The string "123.456" returns "456"
  def test_get_timestamp_nanoseconds
    assert_equal @v.get_timestamp_nanoseconds("1518892051.737141000"), "737141000"
  end

end
