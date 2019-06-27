defmodule CraftchaWeb.PlayerController do
  use CraftchaWeb, :controller
  alias Craftcha.Player

  def new(conn, _params) do
    render conn, "new_player.html"
  end

  def create(conn, _params) do
    %{"player"=> player} = conn.params
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


end
