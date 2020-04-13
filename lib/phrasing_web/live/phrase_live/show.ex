defmodule PhrasingWeb.PhraseLive.Show do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}
  import Phoenix.HTML.Form

  alias Phrasing.Dict
  alias PhrasingWeb.UILive

  @defaults %{
    changeset: nil
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

  def handle_event("toggle_edit", _params, socket) do
    if socket.assigns.changeset do
      {:noreply, assign(socket, changeset: nil)}
    else
      {:noreply, assign(socket, changeset: Dict.change_phrase(socket.assigns.phrase))}
    end
  end
end
