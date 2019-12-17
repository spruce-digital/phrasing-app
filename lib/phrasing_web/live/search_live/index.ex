defmodule PhrasingWeb.SearchLive.Index do
  use Phoenix.LiveView

  alias PhrasingWeb.UILive
  alias Phoenix.HTML.Form
  alias Phrasing.Dict
  alias Paasaa

  @defaults %{
    detect_source: true,
    detect_translations: true,
    search: %{translations: %{}},
    searched: false,
    source_language: nil,
    translation_languages: [],
  }

  def mount(%{user_id: user_id}, socket) do
    languages = Dict.list_languages()
    {:ok, assign(socket, Map.merge(@defaults, %{user_id: user_id, languages: languages}))}
  end

  def render(assigns) do
    ~L"""
    <div class="search--index">
      <form phx-submit="search" phx-change="change">
        <%= render_source assigns %>
        <%= for l <- @translation_languages do %>
          <%= render_translation assigns, l %>
        <% end %>
      </form>
      <ul>
        <li>Existing phrases</li>
        <li>Other phrases</li>
        <li>Library</li>
        <li>Look up</li>
      </ul>
    </div>
    """
  end

  def render_source(assigns) do
    ~L"""
    <div class="search--index--source">
      <input type="text" name="search[source]" value="<%= assigns.search["source"] %>" />
      <button type="submit">
        <%= if assigns.source_language == nil do %>
          <i class="fal fa-search"></i>
        <% else %>
          <%= render_language(assigns, :source) %>
        <% end %>
      </button>
    </div>
    """
  end

  def render_translation(assigns, language_id) do
    ~L"""
    <div class="search--index--translation">
      <input type="text" name="search[translations][<%= language_id %>]" value="<%= assigns.search["translations"][language_id] %>" />
      <button type="submit">
        <%= render_language(assigns, language_id) %>
      </button>
    </div>
    """
  end

  def render_language(assigns, :source), do: render_language(assigns, assigns.source_language)
  def render_language(assigns, language_id) do
    language = Enum.find(assigns.languages, fn l -> l.id == language_id end)

    language.code
  end

  def handle_event("change", %{"_target" => ["search", "source"], "search" => search_params}, socket) do
    search = Map.put socket.assigns.search, "source", search_params["source"]

    source_language = case detect_language(:source, search["source"], socket.assigns) do
      {:ok, language} -> language.id
      {:noop, id} -> id
      {:error} -> nil
    end

    translation_languages = case detect_language(:translations, source_language, socket.assigns) do
      {:noop, translations} -> translations
      {:ok, translations} -> translations
    end

    IO.inspect translation_languages

    {:noreply, assign(socket, search: search, source_language: source_language, translation_languages: translation_languages)}
  end

  def handle_event("change", %{"_target" => ["search", "translations", language_id], "search" => search_params}, socket) do
    search = Map.put socket.assigns.search, "translations", search_params["translations"]
    {:noreply, assign(socket, search: search)}
  end

  def handle_event("search", _params, socket) do
    {:noreply, assign(socket, searched: true)}
  end

  defp detect_language(:source, query, assigns) do
    languages = assigns.languages

    unless assigns.detect_source do
      {:noop, assigns.source_language}
    else
      case Paasaa.detect(query) do
        "und" -> {:error}
        "eng" -> {:ok, Enum.find(languages, fn l -> l.code == "en" end)}
        "fra" -> {:ok, Enum.find(languages, fn l -> l.code == "fr" end)}
        "ita" -> {:ok, Enum.find(languages, fn l -> l.code == "it" end)}
        "hin" -> {:ok, Enum.find(languages, fn l -> l.code == "hi" end)}
        lang? ->
          IO.puts "unhandled language #{lang?} in PhrasingWeb.SearchLive.Index#detect_language"
          {:error}
      end
    end
  end

  defp detect_language(:translations, source_language, assigns) do
    cond do
      assigns.detect_translations == false ->
        {:noop, assigns.translation_languages}

      source_language == nil ->
        {:noop, assigns.translation_languages}

      source_language == assigns.source_language ->
        {:noop, assigns.translation_languages}

      true ->
        translation_languages = Dict.get_last_translations(user_id: assigns.user_id, language_id: source_language)
        {:ok, translation_languages}
    end
  end
end
