defmodule PhrasingWeb.PhraseLive.New do
  use Phoenix.LiveView

  alias Phrasing.Dict
  alias Phrasing.Dict.Phrase
  alias Phrasing.SRS
  alias PhrasingWeb.PhraseView
  alias PhrasingWeb.Router.Helpers, as: Routes
  alias Ecto.Changeset

  def mount(_session, socket) do
    changeset = Dict.change_phrase(%Phrase{})
    languages = Phrase.languages
    dialects = languages
               |> List.first
               |> Access.get(:value)
               |> Phrase.dialects

    {:ok, assign(socket, changeset: changeset, languages: languages, dialects: dialects)}
  end

  def render(assigns) do
    PhraseView.render("new.html", assigns)
  end

  def handle_event("create", %{"phrase" => phrase_params}, socket) do
    case Dict.create_phrase(phrase_params) do
      {:ok, phrase} ->
        SRS.create_card %{phrase: phrase}
        {:stop,
          socket
          |> put_flash(:info, "Phrase created successfully.")
          |> redirect(to: Routes.phrase_path(socket, :show, phrase))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("change", %{"phrase" => phrase_params}, socket) do
    IO.inspect phrase_params

    prev_lang = Access.get socket.assigns, :lang
    # prev_dialect = Access.get socket.assigns, :dialect
    next_lang = phrase_params["lang"]
    next_dialect = phrase_params["dialect"]

    dialects = cond do
      prev_lang != next_lang ->
        Phrase.dialects next_lang
      next_dialect ->
        Phrase.dialects next_lang
      true ->
        Phrase.dialects next_lang
    end

    changeset = cond do
      prev_lang != next_lang ->
        socket.assigns.changeset
        |> Changeset.delete_change(:dialect)
      true ->
        socket.assigns.changeset
    end

    {:noreply, assign(socket, lang: next_lang, dialect: next_dialect, dialects: dialects, changeset: changeset)}
  end
end
