defmodule PhrasingWeb.Router do
  use PhrasingWeb, :router
  import PhrasingWeb.Helpers.Auth, only: [check_auth: 2]
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_live_layout, {PhrasingWeb.LayoutView, "app.html"}
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

    live "/", SearchLive.Index, :index
    live "/profile", ProfileLive.Index, :index
    get "/library", LibraryController, :index
    get "/flashcards", SRSController, :flashcards
    get "/cards", SRSController, :cards
    get "/admin", AdminController, :index
    resources "/scripts", ScriptController, only: [:new]
    resources "/songs", SongController, only: [:new]
    resources "/books", BookController, only: [:new]
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhrasingWeb do
  #   pipe_through :api
  # end
end
