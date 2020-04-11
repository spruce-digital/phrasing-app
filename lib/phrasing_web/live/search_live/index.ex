defmodule PhrasingWeb.SearchLive.Index do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}
  import Ecto.Changeset

  alias Paasaa
  alias Phoenix.HTML.Form
  alias Phrasing.Dict
  alias Phrasing.Dict.{Phrase, Search}
  alias PhrasingWeb.{SearchLive, UILive}

  @defaults %{
    detect: true,
    error: nil,
    last_paired_languages: [],
    message: nil,
    results: [],
    search: %Search{},
    state: :pristine,
    suggestions: []
  }

  def mount(_params, %{"current_user_id" => user_id}, socket) do
    languages = Dict.list_languages()
    recent_phrases = Dict.list_phrases(user_id)

    socket =
      socket
      |> assign_state(@defaults.state)
      |> assign(@defaults)
      |> assign(%{
        user_id: user_id,
        languages: languages,
        recent_phrases: recent_phrases
      })

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="search--index">
      <main>
        <%= if @error do %>
          <h4><%= @error %></h4>
        <% end %>
        <%= if @message do %>
          <h4><%= @message %></h4>
        <% end %>

        <%= live_component @socket, SearchLive.SearchField, id: :search_field,
          search: @search,
          languages: @languages
        %>

        <%= render_body assigns %>
      </main>
    </div>
    """
  end

  def render_body(a) do
    case a.state do
      :pristine ->
        live_component(a.socket, SearchLive.RecentPhrases,
          id: :pristine,
          search: a.search,
          recent_phrases: a.recent_phrases,
          user_id: a.user_id
        )

      :searching ->
        live_component(a.socket, SearchLive.Suggestions,
          # id: :suggestions,
          languages: a.languages,
          phrases: a.suggestions,
          search: a.search
        )

      :results ->
        live_component(a.socket, SearchLive.Results,
          id: :results,
          results: a.results,
          search: a.search,
          user_id: a.user_id
        )
    end
  end

  def handle_info({:select_language, language_id}, socket) do
    IO.puts(:handle_info)
    search = Map.put(socket.assigns.search, :language_id, language_id)

    socket =
      socket
      |> assign_search(search)
      |> assign_state(search)

    {:noreply, socket}
  end

  def handle_event("query", %{"_target" => ["search", field], "search" => search_params}, socket) do
    search = Search.new(search_params)

    socket =
      socket
      |> assign_search(search)
      |> assign_state(search)

    {:noreply, socket}
  end

  def handle_event("search", _params, socket) do
    {:noreply,
     socket
     |> assign_state(:results)
     |> assign(state: :results, results: socket.assigns.suggestions)}
  end

  def handle_event("create_phrase", _params, socket) do
    case Dict.create_phrase(socket.assigns.search, socket.assigns.user_id) do
      {:ok, phrase} ->
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        error =
          cond do
            Keyword.has_key?(changeset.errors, :language_id) -> "Invalid language"
            Keyword.has_key?(changeset.errors, :text) -> "Invalid translation text"
            true -> "An error occurred"
          end

        {:noreply, put_flash(socket, :error, error)}
    end
  end

  ## PRIVATE ##################################################################

  defp assign_state(socket, %Search{} = search) do
    state = if search.text == "", do: :pristine, else: :searching

    socket
    |> assign(state: state)
    |> put_flash(:dev, "state:#{state}")
  end

  defp assign_state(socket, state) do
    socket
    |> assign(state: state)
    |> put_flash(:dev, "state:#{state}")
  end

  defp assign_search(socket, search) do
    IO.inspect(search, label: :assign_search)
    suggestions = if search.text == "", do: [], else: Dict.search(search)
    state = if search.text == "", do: :pristine, else: :searching

    assign(socket, search: search, suggestions: suggestions)
  end
end
