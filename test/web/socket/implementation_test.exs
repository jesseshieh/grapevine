defmodule Web.Socket.ImplementationTest do
  use Gossip.DataCase

  alias Web.Socket.Implementation

  describe "authenticating" do
    setup do
      %{state: %{status: "inactive"}, game: create_game(create_user())}
    end

    test "validating authentication", %{state: state, game: game} do
      frame = %{
        "event" => "authenticate",
        "payload" => %{
          "client_id" => game.client_id,
          "client_secret" => game.client_secret,
        },
      }

      {:ok, response, state} = Implementation.receive(state, frame)

      assert response.status == "success"

      assert state.status == "active"
      assert state.game.id == game.id
    end

    test "invalid credentials", %{state: state, game: game} do
      frame = %{
        "event" => "authenticate",
        "payload" => %{
          "client_id" => game.client_id,
          "client_secret" => "bad",
        },
      }

      {:ok, response, state} = Implementation.receive(state, frame)

      assert response.status == "failure"
      assert state.status == "inactive"
    end
  end

  describe "post a new message" do
    setup do
      user = create_user()
      game = create_game(user)

      state = %{
        status: "active",
        game: game,
      }

      %{state: state, game: game}
    end

    test "broadcasts the message", %{state: state, game: game} do
      Web.Endpoint.subscribe("channels:gossip")

      frame = %{
        "event" => "messages/new",
        "payload" => %{
          "channel" => "gossip",
          "name" => "Player",
          "message" => "Hello!",
        },
      }

      assert {:ok, _state} = Implementation.receive(state, frame)

      game_name = game.short_name
      assert_receive %{payload: %{"channel" => "gossip", "game" => ^game_name}}
    end
  end
end