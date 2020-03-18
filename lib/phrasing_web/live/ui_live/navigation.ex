defmodule PhrasingWeb.UILive.Navigation do
  use Phoenix.LiveComponent

  import Phoenix.HTML.Link

  alias PhrasingWeb.Router.Helpers, as: Routes
  alias PhrasingWeb.Helpers.Auth

  def render(assigns) do
    ~L"""
    <header class="ui--navigation">
      <nav>
        <ul>
          <li><a href="/">Phrasing</a></li>
          <li></li>

          <%= if true do %>
            <li><a href="/cards">Cards</a></li>
            <li><%= link "Sign Out", to: Routes.session_path(@socket, :delete), method: :delete %></li>
          <% else %>
            <li><%= link "Sign In", to: Routes.session_path(@socket, :new) %></li>
            <li><%= link "Sign Up", to: Routes.user_path(@socket, :new) %></li>
          <% end %>
        </ul>
      </nav>
    </header>
    """
  end

  def update(assigns, socket) do
    user = if assigns.user_id do
      Phrasing.Repo.get(Phrasing.Accounts.User, assigns.user_id)
    else
      nil
    end

    {:ok, assign(socket, user: user)}
  end
end
