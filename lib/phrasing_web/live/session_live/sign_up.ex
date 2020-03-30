defmodule PhrasingWeb.SessionLive.SignUp do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}
  import Phoenix.HTML.Form

  alias Phrasing.Accounts
  alias Phrasing.Accounts.User
  alias PhrasingWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <%= f = form_for @changeset, Routes.user_path(@socket, :create), [as: :session], fn f -> %>
      <div class="g--container">
        <header>
          Sign Up
        </header>

        <main>
          <div class="g--input top">
            <%= label f, :email %>
            <%= text_input f, :email %>
          </div>

          <div class="g--input bottom">
            <%= label f, :password %>
            <%= password_input f, :encrypted_password %>
          </div>
        </main>

        <footer>
          <%= submit "Sign up", class: "g--button" %>
        </footer>
      </div>
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user(%User{})
    {:ok, assign(socket, changeset: changeset)}
  end
end
