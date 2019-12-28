defmodule PhrasingWeb.SearchLive.Suggestions do
  use Phoenix.LiveComponent

  alias PhrasingWeb.SearchLive

  def render(assigns) do
    ~L"""
    <div class="search--suggestions">
      <%= for phrase <- @suggestions do %>
        <%= live_component @socket, SearchLive.Phrase, phrase: phrase %>
      <% end %>
    </div>
    """
  end
end
