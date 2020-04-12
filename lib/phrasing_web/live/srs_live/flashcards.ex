defmodule PhrasingWeb.SRSLive.Flashcards do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}

  alias Phrasing.SRS
  alias Phrasing.SRS.Card
  alias PhrasingWeb.FlashcardsView

  def deconstruct_queue([]), do: [nil]
  def deconstruct_queue(queue), do: queue

  def render_score(assigns) do
    ~L"""
    <div class="score score-more">
      <i class="fal fa-bars"></i>
    </div>
    """
  end

  def render_score(assigns, score) when score < 6 do
    class =
      Enum.at(
        [
          "fal fa-exclamation-square",
          "fal fa-tired",
          "fal fa-times",
          "fal fa-repeat",
          "fal fa-check",
          "fal fa-laugh-beam"
        ],
        score
      )

    ~L"""
    <div class="score score-#{score}" phx-click="score" phx-value-score="#{score}">
      <i class="<%= class %>"></i>
    </div>
    """
  end

  def mount(_params, %{"current_user_id" => user_id}, socket) do
    [current | queue] = deconstruct_queue(SRS.queued_cards(user_id))
    history = []

    {:ok,
     assign(socket,
       current: current,
       flipped: false,
       history: history,
       queue: queue,
       user_id: user_id
     )}
  end

  def handle_event("flip", _params, socket) do
    {:noreply, assign(socket, flipped: true)}
  end

  def handle_event("score", %{"score" => score}, socket) do
    case SRS.score_card(socket.assigns.current, String.to_integer(score)) do
      {:ok, card} ->
        history = [card | socket.assigns.history]
        [current | queue] = deconstruct_queue(SRS.queued_cards(socket.assigns.user_id))

        {:noreply,
         assign(socket, history: history, current: current, queue: queue, flipped: false)}

      {:error, _msg} ->
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
