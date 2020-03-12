defmodule PhrasingWeb.PhraseLive.Index do
  use Phoenix.LiveView

  alias Phrasing.Dict
  alias Phrasing.SRS
  alias PhrasingWeb.PhraseView

  def mount(%{"user_id" => user_id}, socket) do
    if connected?(socket), do: Dict.subscribe()
    phrases = Dict.list_phrases(user_id)
    {:ok, assign(socket, phrases: phrases, changeset: nil)}
  end

  def render(assigns) do
    PhraseView.render("index.html", assigns)
  end

  def handle_info({:phrase_update, _phrase}, socket) do
    phrases = Dict.list_phrases()
    {:noreply, assign(socket, phrases: phrases)}
  end

  def handle_info({:phrase_input, changeset}, socket) do
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("create_card", %{"id" => id, "translation" => translation}, socket) do
    phrase = socket.assigns.phrases
             |> Enum.find(fn p -> p.id == String.to_integer(id) end)

    case SRS.create_card(%{phrase: phrase, lang: phrase.lang, translation: translation}) do
      {:ok, card} ->
        phrases = Dict.list_phrases()
        {:noreply, assign(socket, phrases: phrases)}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  def handle_event("delete:" <> phrase_id, _params, socket) do
    phrase_id = String.to_integer(phrase_id)

    socket.assigns.phrases
      |> Enum.find(&(&1.id == phrase_id))
      |> Dict.delete_phrase()

    phrases = socket.assigns.phrases
      |> Enum.filter(&(&1.id != phrase_id))

    {:noreply, assign(socket, phrases: phrases)}
  end
end
