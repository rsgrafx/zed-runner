defmodule ZedRunner.TransactionWorker do
  use GenServer

  alias ZedRunner.Transaction

  def whereis(hash) do
    Registry.lookup(Registry.TransactionWorkers, hash)
  end

  @spec start(Transaction.t) :: any
  def start(transaction) do
    GenServer.start_link(__MODULE__, %{
      transaction: transaction,
      payload: %{}
      }, name: ZedRunner.via_registry_name(transaction.hash))
  end


  def update_status(pid, payload) do
    GenServer.cast(pid, {:update_status, payload})
  end

  @impl true
  def init(init) do
    Process.send_after(self(), :check_status, 5000)
    {:ok, init}
  end

  @impl true
  def handle_cast({:update_status, %{"status" => status} = payload}, state) do
    state = Map.merge(state, %{
      status: status,
      payload: payload
    })

    {:noreply, state}
  end

  @impl true
  def handle_info(:check_status, %{payload: %{"status" => "pending"}} = state) do
    {:noreply, state}
  end

  def handle_info(:check_status, state) do
    Process.send_after(self(), :check_status, 5000)
    IO.inspect(state)
    IO.puts " * transaction state is state. #{state.payload["status"]}"
    {:noreply, state}
  end

end
