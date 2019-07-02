defmodule CraftchaWeb.PlayerController do
  use CraftchaWeb, :controller
  alias Craftcha.Player
  alias Craftcha.Scenario

  def new(conn, _params) do
    render conn, "new_player.html"
  end

  def create(conn, _params) do
    %{"player" => player} = conn.params
    %{"hostname" => hostname, "name" => name} = player
    {:ok, new_player_id} = Player.add_player(hostname, name)
    redirect(conn, to: player_path(conn, :show, new_player_id))
  end

  def index(conn, _params) do
    players = Player.list_players()
    render(conn, "index.html", players: players)
  end

  def check(conn, %{"id" => id}) do
    result = Player.check(id)
    redirect(conn, to: player_path(conn, :show, id))
  end

  def show(conn, %{"id" => id}) do
    player = Player.get_player(id)
    specs = Enum.map(0..player.level, &Scenario.get_instructions/1)
    if (Player.has_finished(id)) do
      render(conn, "end.html", player: player, id: id)
    else
      render(conn, "show.html", player: player, id: id, specs: specs)
    end
  end

  def me(%{remote_ip: ip}, params) do
    IO.inspect(ip, label: "ip")
  end

end
