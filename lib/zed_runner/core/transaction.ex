defmodule ZedRunner.Transaction do
  @moduledoc "Modeled off the Block Native transaction json payload"

  alias __MODULE__

  defstruct [:apiKey, :hash, :txid, :blockchain, :network, :status, :payload]

  @type txnid :: String.t()
  @type t :: %{
          apiKey: String.t(),
          hash: String.t(),
          txid: txnid,
          blockchain: String.t(),
          network: String.t(),
          status: atom(),
          payload: %{}
        }

  def build(txnid) do
    %{
      apiKey: ZedRunner.block_native_api_key(),
      blockchain: "ethereum",
      network: "main",
      hash: txnid,
    }
  end
end

defimpl Jason.Encoder, for: ZedRunner.Transaction do
  def encode(value, opts) do
    Jason.Encode.map(
      Map.take(value, [:apiKey, :hash, :txid, :blockchain, :network, :status, :payload]),
      opts
    )
  end
end
