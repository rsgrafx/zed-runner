defmodule ZedRunner.Repo do
  use Ecto.Repo,
    otp_app: :zed_runner,
    adapter: Ecto.Adapters.Postgres
end
