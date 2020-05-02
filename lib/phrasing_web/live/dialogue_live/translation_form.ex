defmodule PhrasingWeb.DialogueLive.TranslationForm do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form
  import Ecto.Changeset

  alias PhrasingWeb.UILive.Field

  @defaults %{
    submit_action: :create
  }

  def update(assigns, socket) do
    socket =
      socket
      |> assign(@defaults)
      |> assign(assigns)
      |> assign_id()

    {:ok, socket}
  end

  defp assign_id(socket) do
    ids = [
      "tr",
      get_field(socket.assigns.changeset, :language_id),
      get_field(socket.assigns.changeset, :line_id),
      get_field(socket.assigns.changeset, :id, "0")
    ]

    assign(socket, id: Enum.join(ids, "_"))
  end
end
