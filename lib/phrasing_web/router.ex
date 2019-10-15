defmodule PhrasingWeb.Router do
  use PhrasingWeb, :router

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

  scope "/", PhrasingWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/flashcards", SRSController, :flashcards
    resources "/phrases", PhraseController
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhrasingWeb do
  #   pipe_through :api
  # end
end
