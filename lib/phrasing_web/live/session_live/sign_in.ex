defmodule PhrasingWeb.SessionLive.SignIn do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}
  import Phoenix.HTML.Form

  alias PhrasingWeb.Router.Helpers, as: Routes
  alias PhrasingWeb.UILive.Field
  alias Phrasing.Account

  def render(assigns) do
    form_opts = [id: __MODULE__, phx_change: :change]

    ~L"""
    <%= f = form_for @changeset, Routes.session_path(@socket, :create), form_opts %>
      <div class="g--container">
        <header>
          <h1>
            Sign in
          </h1>
        </header>

        <main>
          <%= live_component @socket, Field.Text, id: :email,
            attr: :email,
            change_target: __MODULE__,
            form: f,
            icon: "far fa-at",
            autofocus: true
          %>

          <%= live_component @socket, Field.Password, id: :password,
            attr: :password,
            change_target: __MODULE__,
            form: f,
            icon: "far fa-key"
          %>

        </main>

        <footer>
          <%= submit "Sign in", class: "g--button-full" %>

          <h5>
            Already have an account? <a href="/signup">Sign up</a> here
          </h5>
        </footer>
      </div>
    </form>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Account.change_user_signin(%Account.User{})

    {:ok, assign(socket, changeset: changeset)}
  end

  def handle_event("focus", _params, socket), do: {:noreply, socket}

  def handle_event("change", %{"user" => user_params}, socket) do
    changeset =
      %Account.User{}
      |> Account.change_user_signin(user_params)

    {:noreply, assign(socket, changeset: changeset)}
  end
end
