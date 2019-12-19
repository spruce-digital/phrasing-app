defmodule PhrasingWeb.SearchLive.Index do
  use Phoenix.LiveView

  alias PhrasingWeb.UILive
  alias Phoenix.HTML.Form
  alias Phrasing.Dict
  alias Paasaa

  @default_search %{
    source: "",
    source_language: "detect",
    translation_languages: [],
    translations: %{},
  }

  @defaults %{
    detect: true,
    search: @default_search,
    last_paired_languages: [],
    error: nil,
    message: nil,
  }

  def mount(%{user_id: user_id}, socket) do
    languages = Dict.list_languages()
    {:ok, assign(socket, Map.merge(@defaults, %{user_id: user_id, languages: languages}))}
  end

  def render(assigns) do
    ~L"""
    <div class="search--index">
      <%= if @error do %>
        <h4><%= @error %></h4>
      <% end %>
      <%= if @message do %>
        <h4><%= @message %></h4>
      <% end %>
      <form phx-submit="create" phx-change="change">
        <%= render_source assigns %>
        <%= for {l, i} <- Enum.with_index(assigns.search.translation_languages) do %>
          <%= render_translation assigns, l, i %>
        <% end %>
        <a phx-click="add_translation">Add Translation</a>
        <%= unless Enum.empty?(assigns.search.translation_languages) do %>
          <button type="submit">Create Phrase</button>
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
      <input type="text" name="search[source]" value="<%= assigns.search.source %>" />
      <%= render_language_dropdown(assigns, key: :source_language, detect: true, index: nil) %>
    </div>
    """
  end

  def render_translation(assigns, language_id, index) do
    name = "search[translations][]"
    value = Enum.at assigns.search.translations, index

    ~L"""
    <div class="search--index--translation">
      <input type="text" name="<%= name %>" value="<%= value %>" />
      <%= render_language_dropdown(assigns, key: :translation_languages, detect: false, index: index) %>
    </div>
    """
  end

  def render_language_dropdown(assigns, key: key, detect: detect, index: index) do
    name = "search[#{key}]" <> if index, do: "[]", else: ""
    selected = if index do
      assigns.search[key] |> Enum.at(index)
    else
      assigns.search[key]
    end

    ~L"""
    <select class="search--index--language-dropdown" name="<%= name %>">
      <%= if detect do %>
        <option value="detect" <%= html_selected "detect", selected %>>
          ✎
        </option>
      <% else %>
        <option value="" disabled <%= html_selected selected, nil %>>
          v
        </option>
      <% end %>

      <%= for l <- assigns.languages do %>
        <option value="<%= l.id %>" <%= html_selected l.id, selected %>>
          <%= l.code %>
        </option>
      <% end %>
    </select>
    """
  end

  def render_language(assigns, :source), do: render_language(assigns, assigns.search.source_language)
  def render_language(assigns, language_id) do
    language = Enum.find(assigns.languages, fn l -> l.id == language_id end)

    language.code
  end

  def handle_event("add_translation", _params, socket) do
    translation_languages = socket.assigns.search.translation_languages
                          |> assume_next_translation(socket.assigns)

    search = socket.assigns.search
           |> Map.put(:translation_languages, translation_languages)

    {:noreply, assign(socket, search: search)}
  end

  def handle_event("change", %{"_target" => ["search", "source"], "search" => search_params}, socket) do
    source = search_params["source"]

    source_language = case detect_language(:source, source, socket.assigns) do
      {:ok, language} -> language.id
      {:noop, id} -> id
      {:error} -> nil
    end

    search = socket.assigns.search
    |> Map.put(:source, search_params["source"])
    |> Map.put(:source_language, source_language)

    {:noreply, assign(socket, search: search)}
  end

  def handle_event("change", %{"_target" => ["search", "translations"], "search" => search_params}, socket) do
    search = Map.put socket.assigns.search, :translations, search_params["translations"]
    {:noreply, assign(socket, search: search)}
  end

  def handle_event("change", %{"_target" => ["search", "translation_languages"], "search" => search_params}, socket) do
    search = Map.put socket.assigns.search, :translation_languages, search_params["translation_languages"]
    {:noreply, assign(socket, search: search)}
  end

  def handle_event("change", %{"_target" => ["search", "source_language"], "search" => search_params}, socket) do
    source_language = search_params["source_language"]
    detect = source_language == "detect"
    last_paired_languages = get_last_paired_languages source_language, socket.assigns

    search = socket.assigns.search
           |> Map.put(:source_language, source_language)

    {:noreply, assign(socket, search: search, detect: detect)}
  end

  def handle_event("create", %{"search" => search_params}, socket) do
    if search_params["source_language"] == "detect" do
      {:noreply, assign(socket, error: "Please select a source language")}
    else
      case search_params
           |> Map.put("user_id", socket.assigns.user_id)
           |> Dict.create_phrase_from_search() do
        {:ok, _phrase} ->
          {:noreply, assign(socket, Map.merge(@defaults, %{error: nil, message: "Success"}))}
        {:error, changeset} ->
          {:noreply, assign(socket, error: List.first(changeset.errors))}
      end
    end
  end

  defp detect_language(:source, query, assigns) do
    languages = assigns.languages

    unless assigns.detect do
      {:noop, assigns.search["source_language"]}
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

  defp get_last_paired_languages(source_language, assigns) do
    if source_language == assigns.search.source_language or source_language == "detect" do
      assigns.last_paired_languages
    else
      Dict.get_last_translations(user_id: assigns.user_id, language_id: source_language)
    end
  end

  defp assume_next_translation(translation_languages, assigns) do
    case assigns.last_paired_languages do
      [] ->  translation_languages ++ [1]
      [x] -> translation_languages ++ [x]
      lns ->
      case lns -- translation_languages do
        []   -> translation_languages ++ [1]
        [x]  -> translation_languages ++ [x]
        lns2 -> translation_languages ++ Enum.slice(lns2, 0, 1)
      end
    end
  end

  defp html_selected(a, b) do
    if to_string(a) == to_string(b), do: "selected", else: ""
  end
end
