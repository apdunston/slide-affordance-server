defmodule SlideAffordanceServerWeb.Router do
  use SlideAffordanceServerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SlideAffordanceServerWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/audience", PageController, :audience
    get "/forward", PageController, :forward
    get "/back", PageController, :back
    get "/reset", PageController, :reset
  end

  # Other scopes may use custom stacks.
  # scope "/api", SlideAffordanceServerWeb do
  #   pipe_through :api
  # end
end
