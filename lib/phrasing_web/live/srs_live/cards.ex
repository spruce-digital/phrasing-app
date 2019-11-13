defmodule PhrasingWeb.SRSLive.Cards do
  use Phoenix.LiveView

  alias PhrasingWeb.CardsView
  alias Phrasing.SRS
  alias Phrasing.Dict

  def mount(_session, socket) do
    cards = SRS.list_active_cards
    {:ok, assign(socket, cards: cards)}
  end

  def render(assigns) do
    CardsView.render("index.html", assigns)
  end

  def handle_event("reset:" <> phrase_id, _params, socket) do
    with phrase       <- Dict.get_phrase!(phrase_id),
         {:ok, _card} <- SRS.create_card(%{phrase: phrase}),
         cards        <- SRS.list_active_cards do
      {:noreply, assign(socket, cards: cards)}
    end
  end
end
