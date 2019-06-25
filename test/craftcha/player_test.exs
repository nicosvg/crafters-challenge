defmodule Craftcha.PlayerTest do
  use ExUnit.Case
  alias Craftcha.Player

  doctest Player

  test "Add player" do
    # Act
    {:ok, uuid} = Player.add_player("localhost", "Nico")
    # Assert
    assert uuid != nil
    servers = Craftcha.Session.get_servers()
    assert Map.has_key?(servers, uuid)
    IO.inspect uuid
  end

  test "Get player" do
    # Arrange
    {:ok, uuid} = Player.add_player("localhost", "Nico")
    # Act
    result = Player.get_player(uuid)
    # Assert
    assert result == %Player{hostname: "localhost", name: "Nico"}
  end

  test "Should get 100 points when all levels are ok" do
    # Arrange
    results_list = [true, true, true, true]
    # Act
    points = Player.get_points(results_list)
    # Assert
    assert points == 100
  end

  test "Should get -10 points if the last level is not ok" do
    # Arrange
    results_list = [true, true, true, false]
    # Act
    points = Player.get_points(results_list)
    # Assert
    assert points == -10
  end

  test "Should get -50 points if one of the previous levels is in error" do
    # Arrange
    results_list = [true, false, true, true]
    # Act
    points = Player.get_points(results_list)
    # Assert
    assert points == -50
  end

  test "Should get -50 points for each of the previous levels in error" do
    # Arrange
    results_list = [true, false, false, true]
    # Act
    points = Player.get_points(results_list)
    # Assert
    assert points == -100
  end

  test "All levels in error" do
    # Arrange
    results_list = [false, false, false, false]
    # Act
    points = Player.get_points(results_list)
    # Assert
    assert points == -160
  end

end
