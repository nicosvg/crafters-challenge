defmodule Craftcha.Session do

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def add_server(uuid, hostname, name) do
    Agent.update(
      __MODULE__,
      fn (state) ->
        Map.put(state, uuid, %{hostname: hostname, name: name, level: 0})
      end
    )
  end

  def get_servers() do
    Agent.get(
      __MODULE__,
      fn (state) ->
        state
      end
    )
  end

  def get_server(idServer) do
    Agent.get(__MODULE__, fn (state) -> Map.get(state, idServer) end)
  end

end
