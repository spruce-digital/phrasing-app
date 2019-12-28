defmodule PhrasingWeb.UILive.Field.LanguageSelect do
  use Phoenix.LiveComponent

  alias Phrasing.Dict

  def mount(socket) do
    {:ok, assign(socket, value: nil)}
  end

  def render(assigns) do
    ~L"""
    <select name="<%= @name %>">
      <%= for l <- @languages do %>
        <option value="<%= l.id %>" <%= html_selected l.id, @value %>>
          <%= l.name %>
        </option>
      <% end %>
    </select>
    """
  end

  def preload(list_of_assigns) do
    languages = Dict.list_languages()

    Enum.map(list_of_assigns, fn assigns ->
      Map.put(assigns, :languages, languages)
    end)
  end

  defp html_selected(a, b) do
    if to_string(a) == to_string(b), do: "selected", else: ""
  end
end
