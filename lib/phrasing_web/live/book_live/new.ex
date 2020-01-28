defmodule PhrasingWeb.BookLive.New do
  use Phoenix.LiveView

  import Ecto.Changeset, only: [get_field: 2]
  alias Phrasing.Library
  alias Phrasing.Library.Chapter
  alias PhrasingWeb.BookView
  alias PhrasingWeb.Router.Helpers, as: Routes

  def mount(_session, socket) do
    changeset =
      %Library.Book{}
      |> Library.change_book()

    languages = []

    {:ok, assign(socket, changeset: changeset, languages: languages, add_translation: nil)}
  end

  def render(assigns) do
    BookView.render("new.html", assigns)
  end

  def handle_event("language_select", %{"field" => _field}, socket) do
    languages = socket.assigns.languages ++ [socket.assigns.add_translation]
    changeset = Map.put(socket.assigns.changeset, :action, :ignore)

    {:noreply, assign(socket, languages: languages, changeset: changeset, add_translation: nil)}
  end

  def handle_event("add_chapter", _params, socket) do
    chapters = get_field(socket.assigns.changeset, :chapters) ++ [%Chapter{}]

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:chapters, chapters)
      |> Map.put(:action, :ignore)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("change", %{"book" => book_params}, socket) do
    changeset =
      %Library.Book{}
      |> Library.change_book(book_params)
      |> Map.put(:action, :ignore)

    languages =
      [book_params["lang"] | book_params["translations"] || []]
      |> Enum.filter(& &1)

    add_translation = List.first(book_params["add_translation"] || [])

    {:noreply,
     assign(socket, changeset: changeset, languages: languages, add_translation: add_translation)}
  end

  def handle_event("create", %{"book" => book_params}, socket) do
    {chapters_params, just_book_params} = Map.pop(book_params, "chapters")

    with {:ok, book} <- Library.create_book(just_book_params),
         {:ok, _book} <- Library.create_chapters_for_book(book, Map.values(chapters_params)) do
      {:stop,
       socket
       |> put_flash(:info, "Book created successfully.")
       |> redirect(to: Routes.library_path(socket, :index))}
    else
      error ->
        {:noreply, socket}
    end
  end
end
