defmodule PhrasingWeb.AdminLive.Index do
  use Phoenix.LiveView

  alias PhrasingWeb.AdminView
  alias Phrasing.Dict

  def mount(_session, socket) do
    languages = Dict.list_languages()
    language_changeset = Dict.change_language(%Dict.Language{})

    {:ok,
      assign(socket,
        languages: languages,
        language_changeset: language_changeset
      )}
  end

  def render(assigns) do
    AdminView.render("index.html", assigns)
  end

  def handle_event("create_language", %{"language" => language_params}, socket) do
    case Dict.create_language(language_params) do
      {:ok, language} ->
        languages = [language | socket.assigns.languages]
        language_changeset = Dict.change_language(%Dict.Language{})
        {:noreply, assign(socket, languages: languages, language_changeset: language_changeset)}
      {:error, changeset} ->
        {:noreply, assign(socket, language_changeset: changeset)}
    end
  end
end
