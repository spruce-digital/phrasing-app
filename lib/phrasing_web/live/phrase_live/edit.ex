defmodule PhrasingWeb.PhraseLive.Edit do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}

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
end
