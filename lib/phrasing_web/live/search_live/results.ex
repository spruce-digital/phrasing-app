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
    {:ok, assign(socket, a)}
  end

  def render(assigns) do
    ~L"""
    <main class="search--results">
      <ul class="filters">
        <%= if @filter == nil do %>
          <li phx-click="add_phrase"><i class="far fa-plus"></i>&nbsp;&nbsp;Create Phrase</li>
          <li>Languages</li>
          <li>Search Library</li>
          <li>Look up</li>
        <% end %>
      </ul>

      <h3>Your phrases</h3>

      <%= if assigns[:add_phrase] do %>
        <%= live_component @socket,
                           SearchLive.Phrase,
                           id: :add_phrase,
                           phrase: @add_phrase,
                           user_id: @user_id,
                           editing?: true
        %>
      <% end %>

      <%= for phrase <- @results do %>
        <%= if phrase.user_id == @user_id do %>
          <%= live_component @socket,
                             SearchLive.Phrase,
                             id: "result_#{phrase.id}",
                             phrase: phrase,
                             user_id: @user_id,
                             editing?: false
          %>
        <% end %>
      <% end %>

      <h3>All Phrases</h3>

      <%= for phrase <- @results do %>
        <%= if phrase.user_id != @user_id do %>
          <%= live_component @socket,
                             SearchLive.Phrase,
                             id: "result_#{phrase.id}",
                             phrase: phrase,
                             user_id: @user_id,
                             editing?: false
          %>
        <% end %>
      <% end %>
    </main>
    """
  end

  def handle_event("add_phrase", _params, socket) do
    translation = %Translation{
      language_id: socket.assigns.search.language_id,
      source: false,
      text: socket.assigns.search.text,
    }

    phrase = %Phrase{
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

    {:noreply, assign(socket, add_phrase: phrase)}
  end
end
