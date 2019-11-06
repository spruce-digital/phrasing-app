defmodule PhrasingWeb.JournalController do
  use PhrasingWeb, :controller

  alias PhrasingWeb.JournalLive.{New}

  def new(conn, _params) do
    live_render(conn, New, session: %{})
  end
end
