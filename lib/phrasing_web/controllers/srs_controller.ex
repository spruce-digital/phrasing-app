defmodule PhrasingWeb.SRSController do
  use PhrasingWeb, :controller

  alias Phrasing.SRS
  alias PhrasingWeb.SRSLive.{Flashcards}

  def flashcards(conn, _params) do
    live_render(conn, Flashcards, session: %{})
  end
end
