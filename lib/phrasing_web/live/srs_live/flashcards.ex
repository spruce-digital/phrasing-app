defmodule PhrasingWeb.SRSLive.Flashcards do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}

  alias Phrasing.Account
  alias Phrasing.Dict
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
    <div class="score score-<%= score %>" phx-click="score" phx-value-score="<%= score %>">
      <i class="<%= class %>"></i>
    </div>
    """
  end

  def mount(_params, %{"current_user_id" => user_id}, socket) do
    [current | queue] = deconstruct_queue(SRS.queued_cards(user_id))

    user =
      user_id
      |> Account.get_user!()
      |> Phrasing.Repo.preload([:user_languages])

    history = []

    {:ok,
     assign(socket,
       current: current,
       flipped: false,
       history: history,
       queue: queue,
       user: user
     )}
  end

  def handle_event("flip", _params, socket) do
    socket =
      socket
      |> assign(flipped: true)
      |> assign_known_translation()

    {:noreply, socket}
  end

  def handle_event("score", %{"score" => score}, socket) do
    case SRS.score_card(socket.assigns.current, String.to_integer(score)) do
      {:ok, card} ->
        history = [card | socket.assigns.history]
        [current | queue] = deconstruct_queue(SRS.queued_cards(socket.assigns.user.id))

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

  def assign_known_translation(socket) do
    known_language_ids =
      socket.assigns.user.user_languages
      |> Enum.filter(&(&1.level > 50))
      |> Enum.map(& &1.language_id)

    known_translation =
      socket.assigns.current.translation.phrase.translations
      |> Enum.shuffle()
      |> Enum.find(%Dict.Translation{}, &Enum.member?(known_language_ids, &1.language_id))

    IO.inspect(known_translation)

    assign(socket, known_translation: known_translation)
  end
end
