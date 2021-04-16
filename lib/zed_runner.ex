defmodule ZedRunner do
  @moduledoc """
  ZedRunner keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias ZedRunner.TransactionWorker

  def find_and_update(%{"hash" => hash} = params) do
    with pid when is_pid(pid) <- TransactionWorker.whereis(hash),
      true <- Process.alive?(pid),
      :ok <- TransactionWorker.update_status(pid, params) do
        {:ok, :received}
    end
  end

  def block_native_api_key do
    Application.get_env(:zed_runner, :block_native_api)
  end
end
