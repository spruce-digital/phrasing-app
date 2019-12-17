defmodule PhrasingWeb.Router do
  use PhrasingWeb, :router
  import PhrasingWeb.Helpers.Auth, only: [check_auth: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug :check_auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhrasingWeb do
    pipe_through :browser

    resources "/register", UserController, only: [:create, :new]
    get "/signin", SessionController, :new
    post "/signin", SessionController, :create
    delete "/signout", SessionController, :delete

    pipe_through :check_auth

    get "/", SearchController, :index
    get "/library", LibraryController, :index
    get "/flashcards", SRSController, :flashcards
    get "/cards", SRSController, :cards
    get "/admin", AdminController, :index
    resources "/scripts", ScriptController, only: [:new]
    resources "/songs", SongController, only: [:new]
    resources "/books", BookController, only: [:new]
    resources "/phrases", PhraseController
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhrasingWeb do
  #   pipe_through :api
  # end
end
