defmodule PhrasingWeb.SRSLive.Flashcards do
  use Phoenix.LiveView

  alias Phrasing.SRS
  alias PhrasingWeb.SRSView

  def deconstruct_queue([]), do: [nil]
  def deconstruct_queue(queue), do: queue

  def mount(_session, socket) do
    [current|queue] = deconstruct_queue SRS.queued_cards()
    history = []

    {:ok, assign(socket, queue: queue, current: current, history: history, flipped: false)}
  end

  def render(assigns) do
    SRSView.render("flashcards.html", assigns)
  end

  def handle_event("flip", _params, socket) do
    {:noreply, assign(socket, flipped: true)}
  end

  def handle_event("score", %{"score" => score}, socket) do
    case SRS.score_card socket.assigns.current, String.to_integer(score) do
      {:ok, card} ->
        history = [card|socket.assigns.history]
        [current|queue] = deconstruct_queue SRS.queued_cards()

        {:noreply, assign(socket, history: history, current: current, queue: queue, flipped: false)}

      {:error, msg} ->
        {:noreply,
          socket
          |> put_flash(:error, "An error occured")}
    end
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
