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
    # plug :check_auth

    plug CORSPlug,
      origin: ["http://localhost:4500"]
  end

  pipeline :gql do
    plug :accepts, ["json"]
    plug PhrasingWeb.Plugs.AbsintheContext
  end

  scope "/", PhrasingWeb do
    pipe_through :browser

    live "/signin", SessionLive.SignIn, :new
    live "/signup", SessionLive.SignUp, :new
    post "/signin", SessionController, :create
    post "/signup", UserController, :create
    delete "/signout", SessionController, :delete

    pipe_through :check_auth

    live "/", SearchLive.Index, :index
    live "/account", AccountLive.Index, :index
    live "/admin", AdminLive.Index, :index
    live "/cards", SRSLive.Cards, :index
    live "/flashcards", SRSLive.Flashcards, :flashcards
    live "/phrases/:id", PhraseLive.Show, :show
    live "/library", LibraryLive.Index, :index
    live "/dialogues/:id/edit", DialogueLive.Edit, :edit

  end

  scope "/api" do
    if Mix.env == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL, schema: PhrasingWeb.Schema
    end

    pipe_through :gql

    forward "/", Absinthe.Plug, schema: PhrasingWeb.Schema
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhrasingWeb do
  #   pipe_through :api
  # end
end
