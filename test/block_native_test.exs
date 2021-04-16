defmodule BlockNativeTest do
  use ExUnit.Case

  alias ZedRunner.{
    BlockNative,
    TransactionWorker
  }

  describe "Build api calls" do
    test "endpoint/0" do
      assert BlockNative.endpoint() == "https://api.blocknative.com"
    end
  end

  describe "subscribe_and_start/1" do
    test "should make call to BlockNative return accessble pid" do
      txn_id = "0x8867ea9a8845c54935a8986dcbd0287a03bd8e655cf3bc38bc3249682d328c27"
      assert {:ok, pid} = BlockNative.subscribe_and_start(txn_id)
      assert %{
        payload: payload
      } = :sys.get_state(pid)
    end

   test "should update state of process" do
    txn_id = "0x8867ea9a8845c54935a8986dcbd0287a03bd8e655cf3bc38bc3249682d328c27"
    assert {:ok, pid} = BlockNative.subscribe_and_start(txn_id)
    assert TransactionWorker.whereis(txn_id) == pid
   end
  end
end
