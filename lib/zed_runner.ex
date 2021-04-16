defmodule ZedRunner do
  @moduledoc """
  ZedRunner keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias ZedRunner.{BlockNative, TransactionWorker}

  def start_tracking(txn_ids) do
    Enum.each(txn_ids, fn txn_id ->
      BlockNative.subscribe_and_start(txn_id)
    end)
  end

  def via_registry_name(txn_id) do
    {:via, Registry, {Registry.TransactionWorkers, txn_id}}
  end

  def find_and_update(%{"hash" => hash} = params) do
    with [{pid, _}] when is_pid(pid) <- TransactionWorker.whereis(hash),
      true <- Process.alive?(pid),
      :ok <- TransactionWorker.update_status(pid, params) do
        {:ok, :received}
    end
  end

  def find_and_update(params) do
    IO.inspect(params)
    {:error, :notreceived}
  end

  def block_native_api_key do
    Application.get_env(:zed_runner, :block_native_api)
  end
end
