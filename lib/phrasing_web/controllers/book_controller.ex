defmodule PhrasingWeb.BookController do
  use PhrasingWeb, :controller

  alias PhrasingWeb.BookLive.{New}

  def new(conn, _params) do
    live_render(conn, New, session: %{})
  end
end
