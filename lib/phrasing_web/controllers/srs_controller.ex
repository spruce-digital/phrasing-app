defmodule PhrasingWeb.SRSController do
  use PhrasingWeb, :controller

  alias Phrasing.SRS
  alias PhrasingWeb.FlashcardsLive

  def flashcards(conn, _params) do
    live_render(conn, FlashcardsLive.Index, session: %{})
  end
end
