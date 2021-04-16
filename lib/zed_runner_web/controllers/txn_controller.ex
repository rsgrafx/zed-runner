defmodule ZedRunnerWeb.TxnController do
  use ZedRunnerWeb, :controller

  require Logger

  alias ZedRunner

  @doc """
  Request Payload
  %{"txn_ids" => ["txn_id"]}

  Response
  %{data: [
    %{
      txid: "hash",
      status: "pending"
    }
    ]
  }
  """
  def check(conn, %{"txn_ids" => txn_ids}) do
    response = ZedRunner.start_tracking(txn_ids)
    json(conn, %{data: response})
  end

  def update(conn, params) do
    with {:ok, :received} <- ZedRunner.find_and_update(params) do
      send_resp(conn, :ok, "received")
    else
      error ->
        IO.inspect(error)
        Logger.info("Error from received data")
        send_resp(conn, :ok, "received")
    end
  end
end
