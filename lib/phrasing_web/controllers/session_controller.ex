defmodule PhrasingWeb.SessionController do
  use PhrasingWeb, :controller

  alias Phrasing.Account

  def create(conn, %{"user" => user_params}) do
    user = Account.get_by_email(user_params["email"])

    case Bcrypt.check_pass(user, user_params["password"]) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: Routes.search_index_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "There was a problem with your email/password")
        |> redirect(to: Routes.session_sign_in_path(conn, :new))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: Routes.search_index_path(conn, :index))
  end
end
