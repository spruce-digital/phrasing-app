defmodule PhrasingWeb.SongController do
  use PhrasingWeb, :controller

  alias PhrasingWeb.SongLive.{New}

  def new(conn, _params) do
    live_render(conn, New, session: %{})
  end
end
