defmodule PhrasingWeb.PhraseLive.Show do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}
  import Ecto.Changeset

  alias PhrasingWeb.PhraseLive.TranslationForm
  alias Phrasing.Dict
  alias PhrasingWeb.UILive

  @defaults %{
    translations: [],
    guid: 0
  }

  def mount(%{"id" => id}, %{"current_user_id" => user_id}, socket) do
    phrase =
      Dict.get_phrase!(id)
      |> Phrasing.Repo.preload(translations: [:language, :cards])

    socket =
      socket
      |> assign(@defaults)
      |> assign(phrase: phrase, user_id: user_id)

    {:ok, socket}
  end

  def handle_info({:flash, type, message}, socket) do
    {:noreply, put_flash(socket, type, message)}
  end

  def handle_event("add_translation", _params, socket) do
    translation =
      %Dict.Translation{}
      |> Dict.change_translation(%{
        user_id: socket.assigns.user_id,
        phrase_id: socket.assigns.phrase.id,
        guid: socket.assigns.guid
      })

    socket =
      socket
      |> assign(translations: socket.assigns.translations ++ [translation])
      |> assign(guid: socket.assigns.guid + 1)

    {:noreply, socket}
  end

  defp tr_id(%Dict.Translation{} = tr), do: "tr_#{tr.id}"
  defp tr_id(%Ecto.Changeset{} = tr), do: "tr_form_#{get_field(tr, :guid)}"
end
