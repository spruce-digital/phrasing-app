defmodule PhrasingWeb.LibraryLive.Index do
  use Phoenix.LiveView

  alias Phrasing.Library
  alias PhrasingWeb.LibraryView

  def mount(_session, socket) do
    scripts = Library.list_scripts
    songs = Library.list_songs
    books = Library.list_books
    {:ok, assign(socket, scripts: scripts, songs: songs, books: books)}
  end

  def render(assigns) do
    LibraryView.render("index.html", assigns)
  end
end
