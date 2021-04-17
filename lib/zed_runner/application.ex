defmodule ZedRunner.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      # Start the Telemetry supervisor
      ZedRunnerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ZedRunner.PubSub},
      # Start the Endpoint (http/https)
      ZedRunnerWeb.Endpoint,
      {Registry, [keys: :unique, name: Registry.TransactionWorkers]}
      # Start a worker by calling: ZedRunner.Worker.start_link(arg)
      # {ZedRunner.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ZedRunner.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ZedRunnerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
