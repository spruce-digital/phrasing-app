defmodule PhrasingWeb.SearchLive.SearchField do
  use Phoenix.LiveComponent

  def mount(socket) do
    socket =
      socket
      |> assign(field: :text)

    {:ok, socket}
  end

  def update(assigns, socket) do
    IO.inspect(assigns.search)

    socket =
      socket
      |> assign(assigns)

    {:ok, socket}
  end

  def handle_event("select_language", %{"language" => language_id}, socket) do
    send(self(), {:select_language, language_id})

    socket = assign(socket, field: :text)

    {:noreply, socket}
  end

  def handle_event("toggle_field", _params, socket) do
    socket =
      socket
      |> assign(field: toggle_field(socket.assigns.field))

    {:noreply, socket}
  end

  defp flag_code(search, languages) do
    case Enum.find(languages, fn l -> to_string(l.id) == search.language_id end) do
      nil ->
        "default"

      language ->
        language.flag_code
    end
  end

  defp visible_languages(languages, search) do
    q = String.downcase(search.language_text)

    languages
    |> Enum.filter(fn l ->
      String.downcase(l.name) =~ q or String.downcase(l.code) =~ q
    end)
    |> Enum.take(5)
  end

  defp toggle_field(:text), do: :language_text
  defp toggle_field(:language_text), do: :text
end
