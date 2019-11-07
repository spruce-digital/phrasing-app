defmodule PhrasingWeb.SongLive.New do
  use Phoenix.LiveView

  alias Phrasing.Dict
  alias Phrasing.Library
  alias PhrasingWeb.SongView
  alias PhrasingWeb.Router.Helpers, as: Routes

  def mount(_session, socket) do
    changeset = Library.change_song(%Library.Song{})
    languages = Dict.Phrase.languages

    {:ok, assign(socket, changeset: changeset, languages: languages)}
  end

  def render(assigns) do
    SongView.render("new.html", assigns)
  end

  def handle_event("create", %{"song" => song_params}, socket) do
    case Library.create_song(song_params) do
      {:ok, song} ->
        {:stop,
          socket
          |> put_flash(:info, "Song created successfully.")
          |> redirect(to: Routes.library_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
