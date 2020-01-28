defmodule PhrasingWeb.SearchLive.Suggestions do
  use Phoenix.LiveComponent

  alias PhrasingWeb.SearchLive

  def render(assigns) do
    ~L"""
    <div class="search--suggestions">
      <%= for phrase <- @suggestions do %>
        <%= live_component @socket, SearchLive.Phrase, phrase: phrase, id: "suggestion_#{phrase.id}" %>
      <% end %>
    </div>
    """
  end
end
