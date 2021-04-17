defmodule ZedRunnerWeb.TxnView do
  use ZedRunnerWeb, :view

  def render("payload.json", %{data: data, status: status}) do
    results =
      Enum.map(data, fn item ->
        %{
          status: item.status,
          payload: Map.take(item.transaction, [:blockchain, :hash, :network])
        }
      end)

    %{
      meta: "Current #{status}",
      txns: results
    }
  end
end
