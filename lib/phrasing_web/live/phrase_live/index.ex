defmodule PhrasingWeb.PhraseLive.Index do
  use Phoenix.LiveView

  alias Phrasing.Dict
  alias PhrasingWeb.PhraseView

  def mount(_session, socket) do
    if connected?(socket), do: Dict.subscribe()
    phrases = Dict.list_phrases()
    {:ok, assign(socket, phrases: phrases, changeset: nil)}
  end

  def render(assigns) do
    PhraseView.render("index.html", assigns)
  end

  def handle_info({:phrase_update, _phrase}, socket) do
    phrases = Dict.list_phrases()
    {:noreply, assign(socket, phrases: phrases)}
  end

  def handle_info({:phrase_input, changeset}, socket) do
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("delete:" <> phrase_id, _params, socket) do
    phrase_id = String.to_integer(phrase_id)

    socket.assigns.phrases
      |> Enum.find(&(&1.id == phrase_id))
      |> Dict.delete_phrase()

    phrases = socket.assigns.phrases
      |> Enum.filter(&(&1.id != phrase_id))

    {:noreply, assign(socket, phrases: phrases)}
  end
end
