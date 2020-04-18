defmodule PhrasingWeb.SearchLive.Index do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}
  import Ecto.Changeset

  alias Paasaa
  alias Phoenix.HTML.Form
  alias Phrasing.Dict
  alias Phrasing.Dict.{Phrase, Search}
  alias PhrasingWeb.{SearchLive, UILive}
  alias PhrasingWeb.Router.Helpers, as: Routes

  @defaults %{
    filter_translations: false,
    last_paired_languages: [],
    phrases: [],
    search: %Search{}
  }

  def mount(_params, %{"current_user_id" => user_id}, socket) do
    languages = Dict.list_languages()

    socket =
      socket
      |> assign(@defaults)
      |> assign(%{
        user_id: user_id,
        languages: languages
      })
      |> assign_search(%Search{})

    {:ok, socket}
  end

  def handle_info({:select_language, language_id}, socket) do
    search = Map.put(socket.assigns.search, :language_id, language_id)

    socket =
      socket
      |> assign_search(search)

    {:noreply, socket}
  end

  def handle_event("filter", %{"_target" => ["search", field], "search" => search_params}, socket) do
    search = Search.new(search_params)

    socket =
      socket
      |> assign_search(search)
      |> assign(filter_translations: search.text != "")

    IO.inspect(socket.assigns.filter_translations)

    {:noreply, socket}
  end

  def handle_event("keydown", %{"code" => "Enter"}, socket) do
    {:noreply, assign(socket, filter_translations: false)}
  end

  def handle_event("keydown", _params, socket) do
    {:noreply, socket}
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

  def handle_event("show_phrase:" <> id, _params, socket) do
    path = Routes.phrase_show_path(socket, :show, id)
    {:noreply, push_redirect(socket, to: path)}
  end

  ## PRIVATE ##################################################################

  defp assign_search(socket, search) do
    phrases =
      if search.text == "" do
        Dict.list_phrases(socket.assigns.user_id)
        |> Phrasing.Repo.preload(translations: :language)
      else
        Dict.search(search)
      end

    assign(socket, search: search, phrases: phrases)
  end

  defp tr_id(tr), do: "search_phrase_#{tr.phrase_id}_tr_#{tr.id}"

  defp tr_match?(tr, %Search{} = search) do
    String.contains?(String.downcase(tr.text), String.downcase(search.text))
  end
end
