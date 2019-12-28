defmodule PhrasingWeb.SearchLive.SearchField do
  use Phoenix.LiveComponent

  alias Phrasing.Dict

  def mount(socket) do
    languages = Dict.list_languages()
    {:ok, assign(socket, languages: languages)}
  end

  def render(assigns) do
    ~L"""
    <form class="search--search-field" phx-submit="search" phx-change="query">
      <select name="search[language_id]">
        <%= for l <- @languages do %>
          <option value="<%= l.id %>" <%= html_selected l.id, @search.language_id %>>
            <%= l.name %>
          </option>
        <% end %>
      </select>
      <input name="search[text]" value="<%= @search.text %>" />
    </form>
    """
  end

  defp html_selected(a, b) do
    if to_string(a) == to_string(b), do: "selected", else: ""
  end
end
