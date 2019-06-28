defmodule CraftchaWeb.PlayerController do
  use CraftchaWeb, :controller
  alias Craftcha.Player

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
    IO.inspect(player.last_result, label: "last result")
    render(conn, "show.html", player: player, id: id)
  end

  def me(%{remote_ip: ip}, params) do
    IO.inspect(ip, label: "ip")
  end

end
