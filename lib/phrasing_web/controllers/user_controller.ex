defmodule PhrasingWeb.UserController do
  use PhrasingWeb, :controller

  alias Phrasing.Accounts
  alias Phrasing.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Welcome to phrasing.app!")
        |> redirect(to: Routes.library_path(conn, :index, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
