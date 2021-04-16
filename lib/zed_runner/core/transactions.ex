defmodule ZedRunner.Transactions do
  @moduledoc """
  House logic that fetches current processes
  tracking transactions in the system.
  """

  @registry Registry.TransactionWorkers

  def lookup(txn_id) do
    [{pid, _}] = Registry.lookup(@registry, txn_id)
    :sys.get_state pid
  end

  def all do
    results = Registry.select(@registry, [{{:"$1", :"$2", :"$3"}, [], [{{:"$1", :"$2", :"$3"}}]}])
    Enum.map(results, fn {_, pid, _} ->
      :sys.get_state(pid)
    end)
  end

end
