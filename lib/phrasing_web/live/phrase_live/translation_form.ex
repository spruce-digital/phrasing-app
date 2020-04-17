defmodule PhrasingWeb.PhraseLive.TranslationForm do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form

  alias Phrasing.Dict
  alias PhrasingWeb.UILive.Field

  def preload(list_of_assigns) do
    languages = Dict.list_languages()

    Enum.map(list_of_assigns, fn assigns ->
      Map.put(assigns, :languages, languages)
    end)
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def handle_event("validate", %{"translation" => tr_params}, socket) do
    changeset =
      %Dict.Translation{}
      |> Dict.change_translation(tr_params)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"translation" => tr_params}, socket) do
    case Dict.save_translation(tr_params) do
      {:ok, _translation} ->
        send(self(), {:flash, :success, "Translation saved"})
        {:noreply, socket}

      {:error, _changeset} ->
        send(self(), {:flash, :error, "Error saving translation"})
        {:noreply, socket}
    end
  end

  defp form_opts(myself) do
    [phx_change: :validate, phx_submit: :save, phx_target: myself]
  end
end
