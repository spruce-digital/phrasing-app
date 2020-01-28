defmodule PhrasingWeb.AdminController do
  use PhrasingWeb, :controller

  alias PhrasingWeb.AdminLive

  def index(conn, _params) do
    live_render(conn, AdminLive.Index, session: %{
      "user_id" => get_session(conn, "current_user_id")
    })
  end
end
