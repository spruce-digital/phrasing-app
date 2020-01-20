defmodule PhrasingWeb.SearchLive.Results do
  use Phoenix.LiveComponent

  alias PhrasingWeb.SearchLive
  alias PhrasingWeb.UILive
  alias Phrasing.Dict
  alias Phrasing.Dict.{Phrase,Translation}

  def mount(socket) do
    {:ok, assign(socket, filter: nil)}
  end

  def update(a, socket) do
    query_lang = a.search.language_id
    query = a.search.text

    match = Enum.find a.results, fn p ->
      Enum.any? p.translations, fn t ->
        t.language_id == query_lang && t.text == query
      end
    end

    {:ok, assign(socket, Map.put(a, :match, match))}
  end

  def render(assigns) do
    ~L"""
    <main class="search--results">
      <ul class="filters">
        <%= if @filter == nil do %>
          <li>Languages</li>
          <li>Look up</li>

          <%= unless @match do %>
            <spacer></spacer>
            <li phx-click="add_phrase"><i class="far fa-plus"></i></li>
          <% end %>
        <% end %>
      </ul>

      <%= if @match do %>
        <%= live_component @socket,
                           SearchLive.Phrase,
                           id: :result,
                           phrase: @match,
                           user_id: @user_id,
                           editing?: @editing_match?
        %>
      <% end %>

      <ul>
        <li>Your existing translations</li>
        <li>Other existing translations</li>
        <li>Appearences of phrase in your Library (books, songs, scripts, etc)</li>
        <li>Options to look up on Google Translate, WordReference, etc</li>
      </ul>
    </main>
    """
  end

  def handle_event("add_phrase", _params, socket) do
    translation = %Translation{
      language_id: socket.assigns.search.language_id,
      source: true,
      text: socket.assigns.search.text,
    }

    editing_match? = true
    match = %Phrase{
      user_id: socket.assigns.user_id,
      translations: [translation]
      # |> Enum.concat([%Translation{
      #   language_id: 2,
      #   source: false,
      #   text: "Bonjour"
      # }, %Translation{
      #   language_id: 1,
      #   source: false,
      #   text: "Hi",
      # }])
    }

    {:noreply, assign(socket, match: match, editing_match?: editing_match?)}
  end
end
