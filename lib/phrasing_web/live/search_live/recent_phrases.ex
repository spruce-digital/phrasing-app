defmodule PhrasingWeb.SearchLive.RecentPhrases do
  use Phoenix.LiveComponent
  alias PhrasingWeb.SearchLive

  def render(assigns) do
    ~L"""
    <div class="search--recent-phrases">
      <h2>Recent Phrases</h2>
      <%= for phrase <- @recent_phrases do %>
        <%= live_component @socket, SearchLive.Phrase, phrase: phrase %>
      <% end %>
    </div>
    """
  end
end
