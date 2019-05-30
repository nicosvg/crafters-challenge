defmodule Craftcha.PlayerTest do
  use ExUnit.Case

  test "Add player" do
    # Act
    {:ok, uuid} = Craftcha.Player.add_player("localhost", "Nico")
    # Assert
    assert uuid != nil
    servers = Craftcha.Session.get_servers()
    assert Map.has_key?(servers, uuid)
    IO.inspect uuid
  end

  test "Get player" do
    # Arrange
    {:ok, uuid} = Craftcha.Player.add_player("localhost", "Nico")
    # Act
    result = Craftcha.Player.get_player(uuid)
    # Assert
    assert result == %Craftcha.Player{hostname: "localhost", name: "Nico"}
  end
end
