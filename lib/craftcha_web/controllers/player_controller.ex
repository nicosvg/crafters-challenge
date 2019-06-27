defmodule CraftchaWeb.PlayerController do
  use CraftchaWeb, :controller
  alias Craftcha.Player

  def new(conn, _params) do
    render conn, "new_player.html"
  end

  def create(conn, _params) do
    %{"player" => player} = conn.params
    %{"hostname" => hostname, "name" => name} = player
    IO.inspect hostname
    IO.inspect name
    Player.add_player(hostname, name)
    redirect(conn, to: player_path(conn, :index))
  end

  def index(conn, _params) do
    players = Player.list_players()
    IO.inspect players
    render(conn, "index.html", players: players)
  end

  def check(conn, %{"id" => id}) do
    result= Player.check(id)
    IO.inspect(result, label: "result")
    redirect(conn, to: player_path(conn, :show, id))
  end

  def show(conn, %{"id" => id}) do
    player = Player.get_player(id)
    render(conn, "show.html", player: player)
  end

end
