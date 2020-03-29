defmodule PhrasingWeb.SessionLive.SignIn do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}
  import Phoenix.HTML.Form

  alias PhrasingWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <%= f = form_for :foo, Routes.session_path(@socket, :create), [as: :session], fn f -> %>
      <div class="g--container">
        <header>
          Sign in
        </header>

        <main>
          <div class="g--input top">
            <%= label f, :email %>
            <%= text_input f, :email %>
          </div>

          <div class="g--input bottom">
            <%= label f, :password %>
            <%= password_input f, :password %>
          </div>
        </main>

        <footer>
          <%= submit "Sign in", class: "g--button" %>
        </footer>
      </div>
    <% end %>
    """
  end

end
