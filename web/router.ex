defmodule ChattApp.Router do
  use ChattApp.Web, :router

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

  scope "/", ChattApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/mixer", ChattApp do
    pipe_through :browser

    get "/", MusicController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChattApp do
  #   pipe_through :api
  # end
end
