defmodule Craftcha.SessionTest do
  use ExUnit.Case

  test "Add server in session" do
    result = Craftcha.Session.add_server("1", "localhost","Nico")
    assert result == :ok
  end
end
