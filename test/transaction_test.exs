defmodule ZedRunner.TransactionTest do
  use ExUnit.Case

  alias ZedRunner.Transaction

  describe "structure" do
    test "payload structure" do
      assert %{
               apiKey: key,
              #  hash: "txn13232",
               blockchain: "ethereum",
               network: "main"
             } = Transaction.build("txn13232")

      assert not is_nil(key)
    end
  end
end
