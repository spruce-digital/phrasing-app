defmodule PhrasingWeb.SongLive.New do
  use Phoenix.LiveView

  import Ecto.Changeset, only: [get_field: 3, get_field: 2]
  alias Phrasing.Dict
  alias Phrasing.Library
  alias PhrasingWeb.SongView
  alias PhrasingWeb.Router.Helpers, as: Routes

  def mount(_session, socket) do
    changeset = Library.change_song(%Library.Song{})
    languages = []

    {:ok, assign(socket, changeset: changeset, languages: languages, add_translation: nil)}
  end

  def render(assigns) do
    SongView.render("new.html", assigns)
  end

  def handle_event("language_select", %{"field" => field}, socket) do
    languages = socket.assigns.languages ++ [socket.assigns.add_translation]
    changeset = Map.put(socket.assigns.changeset, :action, :ignore)

    {:noreply, assign(socket, languages: languages, changeset: changeset, add_translation: nil)}
  end

  def handle_event("change", %{"song" => song_params}, socket) do
    changeset =
      %Library.Song{}
      |> Library.change_song(song_params)
      |> Map.put(:action, :ignore)

    languages = [song_params["lang"] | song_params["translations"] || []]
                |> Enum.filter(& &1)
    add_translation = List.first(song_params["add_translation"] || [])

    {:noreply, assign(socket, changeset: changeset, languages: languages, add_translation: add_translation)}
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
