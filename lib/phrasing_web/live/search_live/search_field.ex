defmodule PhrasingWeb.SearchLive.SearchField do
  use Phoenix.LiveComponent

  alias Phrasing.Dict

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <form class="search--search-field" phx-submit="search" phx-change="query">
      <input name="search[text]" value="<%= @search.text %>" />
    </form>
    """
  end
end
