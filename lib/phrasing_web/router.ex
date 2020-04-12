defmodule PhrasingWeb.Router do
  use PhrasingWeb, :router
  use Plug.ErrorHandler
  use Sentry.Plug
  import PhrasingWeb.Helpers.Auth, only: [check_auth: 2]
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {PhrasingWeb.LayoutView, "app.html"}
  end

  pipeline :auth do
    plug :check_auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhrasingWeb do
    pipe_through :browser

    resources "/register", UserController, only: [:create]
    live "/signin", SessionLive.SignIn, :new
    live "/signup", SessionLive.SignUp, :new
    post "/signin", SessionController, :create
    delete "/signout", SessionController, :delete

    pipe_through :check_auth

    live "/", SearchLive.Index, :index
    live "/account", AccountLive.Index, :index
    live "/admin", AdminLive.Index, :index
    live "/cards", SRSLive.Cards, :index
    live "/flashcards", SRSLive.Flashcards, :flashcards
    get "/library", LibraryController, :index
    resources "/scripts", ScriptController, only: [:new]
    resources "/songs", SongController, only: [:new]
    resources "/books", BookController, only: [:new]
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhrasingWeb do
  #   pipe_through :api
  # end
end
