defmodule PhrasingWeb.SRSLive.Flashcards do
  use Phoenix.LiveView

  alias Phrasing.SRS
  alias PhrasingWeb.SRSView

  def mount(_session, socket) do
    [current|queue] = SRS.queued_cards()
    history = []

    {:ok, assign(socket, queue: queue, current: current, history: history)}
  end

  def render(assigns) do
    SRSView.render("flashcards.html", assigns)
  end

  def handle_event("score:" <> card_id, %{score: score}, socket) do
    history = [socket.assigns.current|socket.assigns.history]
    [current|queue] = socket.assigns.queue

    {:noreply, assign(socket, history: history, current: current, queue: queue)}
  end
  # def handle_event("delete:" <> phrase_id, params, socket) do
  #   phrase_id = String.to_integer(phrase_id)

  #   socket.assigns.phrases
  #     |> Enum.find(&(&1.id == phrase_id))
  #     |> Dict.delete_phrase()

  #   phrases = socket.assigns.phrases
  #     |> Enum.find(&(&1.id != phrase_id))

  #   {:noreply, assign(socket, phrases: phrases)}
  # end
end
