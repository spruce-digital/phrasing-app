defmodule PhrasingWeb.LibraryLive.Index do
  use Phoenix.LiveView

  alias PhrasingWeb.LibraryView

  def mount(_session, socket) do
    journals = []
    songs = []
    books = []
    {:ok, assign(socket, journals: journals, songs: songs, books: books)}
  end

  def render(assigns) do
    LibraryView.render("index.html", assigns)
  end
end
