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

    {:ok, assign(socket, changeset: changeset, languages: languages)}
  end

  def render(assigns) do
    SongView.render("new.html", assigns)
  end

  def handle_event("language_select", %{"field" => field}, socket) do
    case get_field_from_socket(socket, field) do
      "" -> {:noreply, socket}
      lang ->
        languages = add_languages_from_socket(socket, field, lang)
        {:noreply, assign(socket, languages: languages)}
    end
  end

  def handle_event("change", %{"song" => song_params}, socket) do
    changeset =
      %Library.Song{}
      |> Library.change_song(song_params)
      |> Map.put(:action, :ignore)

    languages = add_languages_from_socket(socket, "lang", song_params["lang"])

    {:noreply, assign(socket, changeset: changeset, languages: languages)}
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

  defp get_field_from_socket(socket, field) do
    changeset = socket.assigns.changeset
    field = get_field changeset, String.to_atom(field), ""

    field
  end

  defp add_languages_from_socket(socket, "lang", lang) do
    languages = socket.assigns.languages

    case languages do
      []      -> [lang]
      [_lang] -> [lang]
      [_lang | added_langs] ->
        [lang | added_langs]
        |> Enum.uniq
    end
  end

  defp add_languages_from_socket(socket, "add_lang", lang) do
    languages = socket.assigns.languages

    case lang do
      nil  -> languages
      ""   -> languages
      lang ->
        languages ++ [lang]
        |> Enum.uniq
    end
  end
end
