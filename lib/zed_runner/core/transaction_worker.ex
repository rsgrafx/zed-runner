defmodule ZedRunner.TransactionWorker do
  use GenServer

  alias ZedRunner.{Transaction, Slack}

  def whereis(hash) do
    Registry.lookup(Registry.TransactionWorkers, hash)
  end

  @spec start(Transaction.t()) :: any
  def start(transaction) do
    GenServer.start_link(
      __MODULE__,
      %{
        transaction: transaction,
        payload: %{}
      },
      name: ZedRunner.via_registry_name(transaction.hash)
    )
  end

  def update_status(pid, payload) do
    GenServer.cast(pid, {:update_status, payload})
  end

  @impl true
  def init(init) do
    {:ok, init}
  end

  @impl true
  def handle_cast({:update_status, %{"status" => status} = payload}, state)
      when status in ["confirmed", "registered"] do
    # Fire *   call to webhook.
    Slack.post_data(%{status: status, transaction_id: payload["hash"]})
    # Keep alive for 1 hour.
    Process.send_after(self, :check_status, 360_000)

    state =
      Map.merge(state, %{
        status: status,
        payload: payload
      })

    {:noreply, state}
  end

  def handle_cast({:update_status, %{"status" => pending} = payload}, state) do
    if pending == "pending" do
      Process.send_after(self, :check_status, 2000)
    end

    state =
      Map.merge(state, %{
        status: pending,
        payload: payload
      })

    {:noreply, state}
  end

  @impl true
  def handle_info(:check_status, %{payload: %{"status" => "pending"}} = state) do
    Process.send_after(self, :check_status, 2000)
    Slack.post_data(%{status: "pending", transaction_id: state.payload["hash"]})
    {:noreply, state}
  end

  # I dont think this will ever get called.
  def handle_info(:check_status, %{payload: %{"status" => status}} = state)
      when status in ["confirmed", "registered"] do
    Slack.post_data(%{status: status, transaction_id: state.payload["hash"]})

    {:noreply, state}
  end

  def handle_info(:check_status, %{payload: %{"status" => status}} = state) do
    {:noreply, state}
  end

  def handle_info(:shutdown, state) do
    IO.puts("completed process")
    {:stop, :completed, state}
  end
end
