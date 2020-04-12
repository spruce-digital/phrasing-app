defmodule PhrasingWeb.SRSLive.Cards do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}

  alias Timex
  alias PhrasingWeb.CardsView
  alias Phrasing.SRS
  alias Phrasing.Dict

  def mount(_params, %{"current_user_id" => user_id}, socket) do
    cards = SRS.list_active_cards(user_id: user_id)

    socket =
      socket
      |> assign(cards: cards, user_id: user_id)

    {:ok, socket}
  end

  def handle_event("reset:" <> phrase_id, _params, socket) do
    with phrase <- Dict.get_phrase!(phrase_id),
         {:ok, _card} <- SRS.create_card(%{phrase: phrase}),
         cards <- SRS.list_active_cards() do
      {:noreply, assign(socket, cards: cards)}
    end
  end

  def handle_event("learn", %{"tr" => tr}, socket) do
    case SRS.learn(translation_id: tr, user_id: socket.assigns.user_id) do
      {:ok, _card} -> {:noreply, socket}
      {:error, _error} -> {:noreply, put_flash(socket, :error, "An error occurred")}
    end
  end

  def handle_event("stop_learning", %{"tr" => tr}, socket) do
    case SRS.stop_learning(translation_id: tr, user_id: socket.assigns.user_id) do
      {:ok, _card} -> {:noreply, socket}
      {:error, _error} -> {:noreply, put_flash(socket, :error, "An error occurred")}
    end
  end

  def if_active(card, active, inactive), do: if(card.active, do: active, else: inactive)
end
