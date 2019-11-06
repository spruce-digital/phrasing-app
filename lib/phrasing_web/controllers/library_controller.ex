defmodule PhrasingWeb.LibraryController do
  use PhrasingWeb, :controller

  alias PhrasingWeb.LibraryLive.{Index}

  def index(conn, _params) do
    live_render(conn, Index, session: %{})
  end
end
