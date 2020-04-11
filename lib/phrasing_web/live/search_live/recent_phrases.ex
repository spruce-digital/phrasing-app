defmodule PhrasingWeb.SearchLive.RecentPhrases do
  use Phoenix.LiveComponent
  alias PhrasingWeb.SearchLive

  def render(assigns) do
    ~L"""
    <div class="search--recent-phrases">
      <h2>Recent Phrases</h2>
      <%= for phrase <- @recent_phrases do %>
        <%= live_component @socket, SearchLive.Phrase,
          id: "recent_#{phrase.id}",
          phrase: phrase,
          search: @search,
          user_id: @user_id
        %>
      <% end %>
    </div>
    """
  end
end
