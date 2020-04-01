defmodule PhrasingWeb.UILive.Navigation do
  use Phoenix.LiveComponent

  import Phoenix.HTML.Link

  alias PhrasingWeb.Router.Helpers, as: Routes
  alias PhrasingWeb.Helpers.Auth

  def render(assigns) do
    ~L"""
    <header class="ui--navigation">
      <nav>
        <ul class="navigation">
          <li class="home"><a href="/">Phrasing</a></li>
          <li class="spacer"></li>

          <%= if @user != nil do %>
            <li><a href="/cards">Cards</a></li>
            <li class="profile">
              <i class="fal fa-user-circle" phx-click="toggle_dropdown" phx-target=".ui--navigation"></i>
              <%= if @open do %>
                <ul class="dropdown">
                  <li><a href="/profile">Profile</a></li>
                  <li><%= link "Sign Out", to: Routes.session_path(@socket, :delete), method: :delete %></li>
                </ul>
              <% end %>
            </li>
          <% else %>
            <li><%= link "Sign In", to: Routes.session_sign_in_path(@socket, :new) %></li>
            <li><%= link "Sign Up", to: Routes.session_sign_up_path(@socket, :new), class: "g--button", style: "margin-bottom: 0" %></li>
          <% end %>
        </ul>
      </nav>
    </header>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, open: false)}
  end

  def update(assigns, socket) do
    user =
      if assigns.user_id do
        Phrasing.Repo.get(Phrasing.Accounts.User, assigns.user_id)
      else
        nil
      end

    {:ok, assign(socket, user: user)}
  end

  def handle_event("toggle_dropdown", _params, socket) do
    {:noreply, assign(socket, open: !socket.assigns.open)}
  end
end
