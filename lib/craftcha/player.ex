defmodule Craftcha.Player do
  defstruct hostname: "", name: "", level: 0

  def add_player(hostname, name) do
    uuid = Ecto.UUID.generate
    Craftcha.Session.add_server(uuid, hostname, name)
    {:ok, uuid}
  end

  def get_player(uuid) do
    player = Craftcha.Session.get_server(uuid)
    struct(Craftcha.Player, player)
  end

  def check(uuid) do
    playerLevel = get_player(uuid).level
    Enum.map(0..playerLevel, fn level -> check_level(uuid, level) end)
  end

  def check_level(uuid, level) do
    case level do
      0 -> check_level_0(uuid)
#      1 -> check_level_1(uuid)
    end
  end

  @doc """
  The player must return a 200 OK with 'Hello World!' as a response
  """
  def check_level_0(uuid) do
    hostname = get_player(uuid).hostname
    {result, response} = :httpc.request(:get, {hostname, []}, [], [])
    case result do
      :ok -> validate_level_0(response)
      :error -> {false, "Could not connect"}
    end
  end

  def validate_level_0({{_, status, _}, _headers, res}) do
    status == 200
    && res == 'Hello World!'
  end

  @doc """
  The player must return a 200 OK with 'Hello World!' as a response
  """
#  def check_level_1(uuid) do
#    hostname = get_player(uuid).hostname
#    {result, response} = :httpc.request(:get, {hostname <> '/status', []}, [], [])
#    case result do
#      :ok -> validate_level_0(response)
#      :error -> {false, "Could not connect"}
#    end
#  end
#
#  def validate_level_1({{_, status, _}, _headers, res}) do
#    status == 200
#    && res == 'Hello World!'
#  end

end
