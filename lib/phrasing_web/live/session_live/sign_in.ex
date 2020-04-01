defmodule PhrasingWeb.SessionLive.SignIn do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}
  import Phoenix.HTML.Form

  alias PhrasingWeb.Router.Helpers, as: Routes
  alias PhrasingWeb.UILive.Field
  alias Phrasing.Accounts

  def render(assigns) do
    form_opts = [id: __MODULE__, phx_change: :change]

    ~L"""
    <%= f = form_for @changeset, Routes.session_path(@socket, :create), form_opts %>
      <div class="g--container">
        <header>
          Sign in
        </header>

        <main>
          <%= live_component @socket, Field.Text,
            attr: :email,
            change_target: __MODULE__,
            form: f,
            icon: "far fa-at",
            id: :email
          %>

          <%= live_component @socket, Field.Password,
            attr: :password,
            change_target: __MODULE__,
            form: f,
            icon: "far fa-key",
            id: :password
          %>

        </main>

        <footer>
          <%= submit "Sign in", class: "g--button-full" %>

          <div>
            Already have an account? <a>Sign In</a> here
          </div>
        </footer>
      </div>
    </form>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_signin(%Accounts.User{})

    {:ok, assign(socket, changeset: changeset)}
  end

  def handle_event("focus", _params, socket), do: {:noreply, socket}

  def handle_event("change", %{"user" => user_params}, socket) do
    changeset =
      %Accounts.User{}
      |> Accounts.change_user_signin(user_params)

    {:noreply, assign(socket, changeset: changeset)}
  end
end
