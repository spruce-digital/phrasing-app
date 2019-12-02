defmodule PhrasingWeb.Helpers.Auth do
  alias PhrasingWeb.Router.Helpers, as: Routes

  def signed_in?(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    if user_id, do: !!Phrasing.Repo.get(Phrasing.Accounts.User, user_id)
  end

  def check_auth(conn, _args) do
    if user_id = Plug.Conn.get_session(conn, :current_user_id) do
      current_user = Phrasing.Repo.get(Phrasing.Accounts.User, user_id)

      conn
      |> Plug.Conn.assign(:current_user, current_user)
    else
      conn
      |> Phoenix.Controller.put_flash(:error, "Please sign in")
      |> Phoenix.Controller.redirect(to: Routes.session_path(conn, :new))
    end
  end
end
