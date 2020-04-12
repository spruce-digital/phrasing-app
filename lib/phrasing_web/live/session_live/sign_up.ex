defmodule PhrasingWeb.SessionLive.SignUp do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}
  import Phoenix.HTML.Form

  alias Phrasing.Account
  alias Phrasing.Account.User
  alias PhrasingWeb.Router.Helpers, as: Routes
  alias PhrasingWeb.UILive.Field

  def render(assigns) do
    ~L"""
    <%= f = form_for @changeset, Routes.user_path(@socket, :create), [as: :session] %>
      <div class="g--container">
        <header>
          <h1>
            Sign up
          </h1>
        </header>

        <main>
          <%= live_component @socket, Field.Text, id: :email,
            change_target: __MODULE__,
            form: f,
            icon: "far fa-at",
            autofocus: true
          %>

          <%= live_component @socket, Field.Password, id: :encrypted_password,
            change_target: __MODULE__,
            label: "Password",
            form: f,
            icon: "far fa-key"
          %>

        </main>

        <footer>
          <%= submit "Sign up", class: "g--button-full" %>

          <h5>
            Already have an account? <a href="/signin">Sign in</a> here
          </h5>
        </footer>
      </div>
    </form>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Account.change_user(%User{})
    {:ok, assign(socket, changeset: changeset)}
  end
end
