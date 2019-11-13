defmodule PhrasingWeb.ScriptController do
  use PhrasingWeb, :controller

  alias PhrasingWeb.ScriptLive.{New}

  def new(conn, _params) do
    live_render(conn, New, session: %{})
  end
end
