defmodule ZedRunner do
  @moduledoc """
  ZedRunner keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def block_native_api_key do
    Application.get_env(:zed_runner, :block_native_api)
  end
end
