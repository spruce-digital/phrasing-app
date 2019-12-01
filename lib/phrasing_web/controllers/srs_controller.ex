defmodule PhrasingWeb.SRSController do
  use PhrasingWeb, :controller

  alias PhrasingWeb.SRSLive

  def flashcards(conn, _params) do
    live_render(conn, SRSLive.Flashcards, session: %{
      user_id: get_session(conn, "current_user_id")
    })
  end

  def cards(conn, _params) do
    live_render(conn, SRSLive.Cards, session: %{})
  end
end
