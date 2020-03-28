defmodule PhrasingWeb.SessionLive.SignIn do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}
  import Phoenix.HTML.Form

  alias PhrasingWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <h1>Sign in</h1>
    <%= f = form_for :foo, Routes.session_path(@socket, :create), [as: :session], fn f -> %>
      <%= text_input f, :email, placeholder: "email" %>
      <%= password_input f, :password, placeholder: "password" %>
      <%= submit "Sign in" %>
    <% end %>
    """
  end

end
