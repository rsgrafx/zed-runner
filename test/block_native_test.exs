defmodule BlockNativeTest do
  use ExUnit.Case

  alias ZedRunner.BlockNative

  describe "Build api calls" do
    test "endpoint/0" do
      assert BlockNative.endpoint() == "https://api.blocknative.com"
    end
  end

  describe "fetch_transaction_data/1" do
    test "should make call to BlockNative" do
      txn_id = "0x8867ea9a8845c54935a8986dcbd0287a03bd8e655cf3bc38bc3249682d328c27"
      assert %{status: status} = BlockNative.status(txn_id)
      assert status in [:pending, :confirmed, :registered, :success]
    end
  end
end
