defmodule PhrasingWeb.AdminLive.Index do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}
  import Phoenix.HTML.Form

  alias PhrasingWeb.UILive.Field
  alias PhrasingWeb.AdminView
  alias Phrasing.Dict

  def getFlagLabel(code), do: "#{code} -- #{Dict.Language.alpha_2_codes()[code]}"

  def mount(params, %{"current_user_id" => user_id}, socket) do
    languages = Dict.list_languages()
    language_changeset = Dict.change_language(%Dict.Language{})

    socket = put_flash(socket, :error, "Danger Zone!")

    {:ok,
     assign(socket,
       user_id: user_id,
       languages: languages,
       language_changeset: language_changeset
     )}
  end

  def handle_event("validate", %{"language" => language_params}, socket) do
    language_changeset =
      socket.assigns.language_changeset.data
      |> Dict.change_language(language_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, language_changeset: language_changeset)}
  end

  def handle_event("create_language", %{"language" => language_params}, socket) do
    IO.inspect(language_params)

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
