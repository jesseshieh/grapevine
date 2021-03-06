defmodule Grapevine.Notifications do
  @moduledoc """
  Notifications context
  """

  alias Grapevine.Emails
  alias Grapevine.Mailer

  def new_game(game) do
    :telemetry.execute([:grapevine, :games, :create], 1, %{id: game.id})

    game
    |> Emails.new_game_registered()
    |> Mailer.deliver_later()
  end
end
