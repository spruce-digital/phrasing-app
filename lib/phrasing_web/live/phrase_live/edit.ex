defmodule PhrasingWeb.PhraseLive.Edit do
  use Phoenix.LiveView

  alias Phrasing.Dict
  alias PhrasingWeb.PhraseView

  def mount(%{id: id}, socket) do
    phrase = Dict.get_phrase!(id)
    changeset = Dict.change_phrase(phrase)

    {:ok, assign(socket, phrase: phrase, changeset: changeset)}
  end

  def render(assigns) do
    PhraseView.render("edit.html", assigns)
  end

  def handle_event("translate", _params, socket) do
    IO.puts "translate from live/edit"
    IO.puts socket.assigns.changeset.data.source
    IO.inspect socket.assigns
    IO.puts "end"
    # TranslatorBridge.broadcast(phrase)

    PhrasingWeb.Endpoint.broadcast! "translate:lobby", "translate", %{
    }

    {:noreply, socket}
  end
end
