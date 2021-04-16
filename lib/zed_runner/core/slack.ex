defmodule ZedRunner.Slack do
  @moduledoc """
  House logic - to call out to slack web hook.
  """

  use Tesla

  plug Tesla.Middleware.BaseUrl, @endpoint
  plug Tesla.Middleware.Headers, [{"Content-Type", "application/json"}]
  plug Tesla.Middleware.JSON

  def post_data(data) do
    data = Jason.encode!(data)

    payload = """
    Code Snippet ```#{data}```
    """

    post(ZedRunner.slack_webhook, %{text: payload})
  end
end
