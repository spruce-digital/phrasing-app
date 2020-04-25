defmodule PhrasingWeb.DialogueLive.Edit do
  use Phoenix.LiveView, layout: {PhrasingWeb.LayoutView, "live.html"}
  import Phoenix.HTML.Form
  import Ecto.Changeset

  alias PhrasingWeb.DialogueLive
  alias Phrasing.Repo
  alias Phrasing.Dict
  alias Phrasing.Library
  alias PhrasingWeb.UILive.Field

  def mount(%{"id" => dialogue_id}, %{"current_user_id" => user_id}, socket) do
    dialogue =
      dialogue_id
      |> Library.get_dialogue!()
      |> Repo.preload(lines: [phrase: :translations])

    Phoenix.PubSub.subscribe(Phrasing.PubSub, "dialogue:#{dialogue_id}")

    socket =
      socket
      |> assign(user_id: user_id)
      |> assign(languages: Dict.list_languages())
      |> assign(dialogue: dialogue)
      |> assign_lines(dialogue.lines)
      |> assign_changeset(dialogue)

    {:ok, socket}
  end

  def handle_info({:dialogue_change, event}, socket) do
    IO.puts(:handle_info)

    dialogue =
      socket.assigns.dialogue.id
      |> Library.get_dialogue!()
      |> Repo.preload(lines: [phrase: :translations])

    socket =
      socket
      |> assign(dialogue: dialogue)
      |> assign_changeset(dialogue)
      |> assign_lines(dialogue.lines)

    {:noreply, socket}
  end

  def handle_event("validate", %{"dialogue" => dialogue_params}, socket) do
    case Library.update_dialogue(socket.assigns.dialogue, dialogue_params) do
      {:ok, dialogue} ->
        socket =
          socket
          |> assign_changeset(dialogue)
          |> put_flash(:dev, "Successfully Created Dialogue")

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign_changeset(changeset)
          |> put_flash(:dev, "Error Updating Dialogue")

        {:noreply, socket}
    end
  end

  defp assign_changeset(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, changeset: changeset)
  end

  defp assign_changeset(socket, %Library.Dialogue{} = dialogue) do
    changeset = Library.change_dialogue(dialogue, %{})

    socket
    |> assign(changeset: changeset)
    |> assign_languages(dialogue)
  end

  defp assign_changeset(socket, dialogue_params) do
    changeset = Library.change_dialogue(socket.assigns.dialogue, dialogue_params)

    socket
    |> assign(changeset: changeset)
    |> assign_languages(changeset)
  end

  defp assign_languages(socket, %Library.Dialogue{} = dialogue) do
    source_language =
      socket.assigns.languages
      |> Enum.find(nil, &(&1.id == dialogue.source_language_id))

    translation_language = nil

    assign(socket, source_language: source_language, translation_language: translation_language)
  end

  defp assign_languages(socket, %Ecto.Changeset{} = changeset) do
    source_language =
      socket.assigns.languages
      |> Enum.find(nil, &(&1.id == get_field(changeset, :source_language_id)))

    translation_language =
      socket.assigns.languages
      |> Enum.find(nil, &(&1.id == get_field(changeset, :translation_language_id)))

    assign(socket, source_language: source_language, translation_language: translation_language)
  end

  defp assign_lines(socket, lines) do
    max =
      (lines ++ [%Library.DialogueLine{position: 1}])
      |> Enum.max_by(& &1.position)

    socket
    |> assign(lines: Enum.sort_by(lines, & &1.position))
    |> assign(max_position: max.position)
  end
end
