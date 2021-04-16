defmodule ZedRunner.BlockNative do
  @moduledoc """
  House functions that call out to Block Native Api
  """
  use Tesla

  alias ZedRunner.TransactionWorker

  @endpoint "https://api.blocknative.com"

  plug Tesla.Middleware.BaseUrl, @endpoint
  plug Tesla.Middleware.Headers, [{"Content-Type", "application/json"}]
  plug Tesla.Middleware.JSON

  alias ZedRunner.Transaction

  @type txn_hash :: String.t()
  @type transaction :: %{
          status: String.t()
        }

  @spec subscribe_and_start(txn_hash) :: transaction
  def subscribe_and_start(txn_hash) do
    data = Transaction.build(txn_hash)
    with {:ok, response } <- post("/transaction", data) do
      status_response(response, data)
    else
      error ->
        IO.inspect(error, label: "Error from API")
        raise ZedRunner.ApiError, message: "Call to BlockNative Api raised"
    end
  end

  defp status_response(%{status: 200, body: %{"msg" => "success"}}, data) do
    TransactionWorker.start(data)
  end

  defp status_response(%{status: code} = _response, _data) when code > 300 do
    raise ZedRunner.ApiError, message: "Call to BlockNative Api raised Error"
  end

  def endpoint do
    @endpoint
  end
end
