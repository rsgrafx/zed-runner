# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :zed_runner,
  ecto_repos: [ZedRunner.Repo]

# Configures the endpoint
config :zed_runner, ZedRunnerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SSG4rXynHk/PHUzjxwA0Wi8+K9ySHM1FcRSp5qaCoOMrP9yAufwL1vcLJMlLeki8",
  render_errors: [view: ZedRunnerWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ZedRunner.PubSub,
  live_view: [signing_salt: "tlbAWq1p"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :zed_runner,
  block_native_api: System.get_env("BLOCK_NATIVE_API"),
  slack_webhook:
    "https://hooks.slack.com/services/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"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
