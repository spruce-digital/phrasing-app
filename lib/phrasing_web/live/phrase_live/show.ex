defmodule PhrasingWeb.PhraseLive.Show do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}
  import Ecto.Changeset

  alias PhrasingWeb.PhraseLive.TranslationForm
  alias Phrasing.Dict
  alias PhrasingWeb.UILive

  @defaults %{
    phrase: %Dict.Phrase{},
    changesets: [],
    guid: 0
  }

  def mount(%{"id" => id}, %{"current_user_id" => user_id}, socket) do
    IO.puts(:mount)

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

  def handle_event("edit", %{"id" => id}, socket) do
    tr =
      socket.assigns.phrase.translations
      |> Enum.find(%Dict.Translation{}, &(to_string(&1.id) == id))

    socket =
      socket
      |> assign_translation_to_changesets(tr)

    {:noreply, socket}
  end

  def handle_event("cancel", %{"guid" => guid}, socket) do
    changesets =
      socket.assigns.changesets
      |> Enum.filter(&(to_string(get_change(&1, :guid)) != guid))

    {:noreply, assign(socket, changesets: changesets)}
  end

  def handle_event("add", _params, socket) do
    socket =
      socket
      |> assign_translation_to_changesets(%Dict.Translation{})

    {:noreply, socket}
  end

  defp translations(trs, chs) do
    subbed =
      Enum.map(trs, fn tr ->
        Enum.find(chs, tr, fn ch -> ch.data.id == tr.id end)
      end)

    Enum.uniq_by(subbed ++ chs, &uniq_by/1)
  end

  defp assign_translation_to_changesets(socket, tr) do
    changeset =
      Dict.change_translation(tr, %{
        user_id: socket.assigns.user_id,
        phrase_id: socket.assigns.phrase.id,
        guid: socket.assigns.guid
      })

    socket
    |> assign(changesets: socket.assigns.changesets ++ [changeset])
    |> assign(guid: socket.assigns.guid + 1)
  end

  defp tr_id(%Dict.Translation{} = tr), do: "tr_#{tr.id}"
  defp tr_id(%Ecto.Changeset{} = tr), do: "tr_form_#{get_field(tr, :guid)}"
  defp tr_type(%Dict.Translation{} = _tr), do: :tr
  defp tr_type(%Ecto.Changeset{} = _ch), do: :ch
  defp uniq_by(%Ecto.Changeset{} = ch), do: ch.data.id
  defp uniq_by(%Dict.Translation{} = tr), do: tr.id
end
