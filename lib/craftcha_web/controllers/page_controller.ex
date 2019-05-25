defmodule CraftchaWeb.PageController do
  use CraftchaWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
