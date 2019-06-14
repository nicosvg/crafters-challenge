defmodule Craftcha.SessionTest do
  use ExUnit.Case
  alias Craftcha.Session

  test "Add server in session" do
    result = Craftcha.Session.add_server("1", "localhost","Nico")
    assert result == :ok
  end

  test "Update player level" do
    # Arrange
    uuid = "1"
    Session.add_server(uuid, "localhost","Nico")
    # Act
    Session.next_level(uuid)
    # Assert
    server = Session.get_server(uuid)
    assert server.level == 1
  end

  test "Add player points" do
    # Arrange
    uuid = "1"
    Session.add_server(uuid, "localhost","Nico")
    # Act
    Session.add_points(uuid, 50)
    # Assert
    player = Session.get_server(uuid)
    assert player.score == 50
  end

  test "Player loses points" do
    # Arrange
    uuid = "1"
    Session.add_server(uuid, "localhost","Nico")
    Session.add_points(uuid, 500)
    # Act
    Session.add_points(uuid, -50)
    # Assert
    player = Session.get_server(uuid)
    assert player.score == 450
  end
end
