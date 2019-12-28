defmodule PhrasingWeb.SearchLive.Index do
  use Phoenix.LiveView

  alias Paasaa
  alias Phoenix.HTML.Form
  alias Phrasing.Dict
  alias Phrasing.Dict.Phrase
  alias PhrasingWeb.SearchLive
  alias PhrasingWeb.UILive

  @default_search %{
    text: "hello",
    language_id: 1,
  }

  @defaults %{
    detect: true,
    error: nil,
    last_paired_languages: [],
    message: nil,
    results: [],
    search: @default_search,
    state: :results,
    suggestions: [],
  }

  def mount(%{user_id: user_id}, socket) do
    languages = Dict.list_languages()
    recent_phrases = Dict.list_phrases(user_id)
    {:ok, assign(socket, Map.merge(@defaults, %{
      user_id: user_id,
      languages: languages,
      recent_phrases: recent_phrases,
    }))}
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

      <%= live_component @socket, SearchLive.SearchField, search: assigns.search %>

      <%= render_body assigns %>
    </div>
    """
  end

  def render_body(a) do
    case a.state do
      :pristine -> live_component a.socket,
                                  SearchLive.RecentPhrases,
                                  recent_phrases: a.recent_phrases
      :searching -> live_component a.socket,
                                   SearchLive.Suggestions,
                                   suggestions: a.suggestions
      :results -> live_component a.socket,
                                 SearchLive.Results,
                                 id: :results,
                                 results: a.results,
                                 search: a.search,
                                 user_id: a.user_id
    end
  end

  def handle_event("query", %{"_target" => ["search", field], "search" => search_params}, socket) do
    search = Map.put socket.assigns.search, String.to_atom(field), search_params[field]
    suggestions = Dict.search_translations(search.text, search.language_id)

    {:noreply, assign(socket, suggestions: suggestions, search: search, state: :searching)}
  end

  def handle_event("search", _params, socket) do
    {:noreply, assign(socket, state: :results)}
  end



  ###############################################
  ### PREVIOUS ##################################
  ###############################################





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


    matching_phrases = get_matching_phrases(search)

    {:noreply, assign(socket, search: search, matching_phrases: matching_phrases)}
  end

  def handle_event("change", %{"_target" => ["search", "translations"], "search" => search_params}, socket) do
    search = Map.put socket.assigns.search, :translations, search_params["translations"]
    matching_phrases = get_matching_phrases(search)
    {:noreply, assign(socket, search: search, matching_phrases: matching_phrases)}
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

  defp get_matching_phrases(search) do
    Dict.search_translations search.source
  end
end
