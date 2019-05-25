defmodule Craftcha.Session do
  use Session

  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  def add_server(pid, host) do
    Agent.update(
      pid,
      fn (state) ->
        Map.put(state, host, 3)
      end
    )
  end
end
