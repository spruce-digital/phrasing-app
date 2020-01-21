defmodule PhrasingWeb.SearchController do
  use PhrasingWeb, :controller

  alias PhrasingWeb.SearchLive

  def index(conn, _params) do
    live_render(conn, SearchLive.Index, session: %{
      "user_id" => get_session(conn, "current_user_id"),
    })
  end
end
