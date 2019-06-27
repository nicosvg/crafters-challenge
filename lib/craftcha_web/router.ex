defmodule CraftchaWeb.Router do
  use CraftchaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CraftchaWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/player", PlayerController, :index
    get "/player/new", PlayerController, :new
    post "/player", PlayerController, :create
    get "/player/:id", PlayerController, :show
    post "/player/:id/check", PlayerController, :check
  end

  # Other scopes may use custom stacks.
  # scope "/api", CraftchaWeb do
  #   pipe_through :api
  # end
end
