defmodule PhrasingWeb.AdminLive.Index do
  use Phoenix.LiveView
  import Phoenix.HTML.Form

  alias PhrasingWeb.AdminView
  alias Phrasing.Dict

  def mount(params, _session, socket) do
    languages = Dict.list_languages()
    language_changeset = Dict.change_language(%Dict.Language{})

    {:ok,
      assign(socket,
        languages: languages,
        language_changeset: language_changeset
      )}
  end

  def render(assigns) do
    ~L"""
      <h1>Danger Zone</h1>

      <hr />

      <h2>Languages</h2>

      <%= for l <- @languages do %>
        <%= l.code %>: <%= l.name %>
      <% end %>

      <%= f = form_for @language_changeset, "#", [phx_submit: :create_language] %>
        <%= label f, :name %>
        <%= text_input f, :name %>

        <%= label f, :code %>
        <%= text_input f, :code %>

        <%= label f, :flag_code %>
        <%= text_input f, :flag_code %>

        <%= submit "Save" %>
      </form>
    """
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
