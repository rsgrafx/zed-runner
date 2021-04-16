defmodule ZedRunnerWeb.TxnController do
  use ZedRunnerWeb, :controller

  require Logger

  alias ZedRunner

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
