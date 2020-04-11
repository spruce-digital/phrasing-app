defmodule PhrasingWeb.SearchLive.Phrase do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form
  import Ecto.Changeset

  alias Phrasing.Dict
  alias Phrasing.SRS
  alias Phrasing.Dict.{Phrase, Translation}
  alias PhrasingWeb.PhraseView
  alias PhrasingWeb.UILive

  def preload(list_of_assigns) do
    languages = Dict.list_languages()

    language_options =
      languages
      |> Enum.map(&[key: &1.name, value: &1.id])
      |> List.insert_at(0, @select_prompt)

    Enum.map(list_of_assigns, fn assigns ->
      assigns
      |> Map.put(:languages, languages)
      |> Map.put(:language_options, language_options)
    end)
  end

  def render(assigns) do
    ~L"""
    <div class="search--phrase">
      <main>
        <ul>
          <%= for tr <- @phrase.translations do %>
            <%= render_translation Map.put(assigns, :translation, tr) %>
          <% end %>
        </ul>
      </main>
    </div>
    """
  end

  def render_translation(assigns) do
    searched_for? = assigns.search.text == assigns.translation.text
    active = !!Enum.find(assigns.translation.cards, & &1.active)

    language =
      assigns.languages
      |> Enum.find(fn language ->
        language.id == assigns.translation.language_id
      end)

    ~L"""
    <li class="search--phrase--translation">
      <aside>
        <span
          class="flag-icon flag-icon-squared flag-icon-<%= language.flag_code %>"
          title="<%= language.name %>"
        ></span>
      </aside>
      <main>
        <p class="text <%= if searched_for?, do: "searched-for", else: "" %>">
          <span class="language-code">
            @<%= language.code %>
          </span>
          <%= assigns.translation.text %>
        <p>
      <div class="learn learn-<%= if active, do: "on", else: "off" %>"
          phx-click="<%= if active, do: "stop_learning", else: "learn" %>"
          phx-target="<%= @myself %>" phx-value-tr="<%= assigns.translation.id %>">
          <i class="<%= if active, do: "fas", else: "fal" %> fa-paper-plane"></i>
        </div>
      </main>
    </li>
    """
  end

  def handle_event("learn", %{"tr" => tr}, socket) do
    case SRS.learn(translation_id: tr, user_id: socket.assigns.user_id) do
      {:ok, _card} -> {:noreply, socket}
      {:error, _error} -> {:noreply, put_flash(socket, :error, "An error occurred")}
    end
  end

  def handle_event("stop_learning", %{"tr" => tr}, socket) do
    case SRS.stop_learning(translation_id: tr, user_id: socket.assigns.user_id) do
      {:ok, _card} -> {:noreply, socket}
      {:error, _error} -> {:noreply, put_flash(socket, :error, "An error occurred")}
    end
  end
end
