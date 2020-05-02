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
      |> assign_dialogue(dialogue)
      |> assign_lines(dialogue)

    {:ok, socket}
  end

  def handle_info({:dialogue_validate, :dialogue, %Ecto.Changeset{} = changeset}, socket) do
    {:noreply, assign_dialogue(socket, changeset)}
  end

  def handle_info({:dialogue_save, :dialogue, event}, socket) do
    {:noreply, socket}
  end

  def handle_info({:dialogue_save, event}, socket) do
    dialogue =
      socket.assigns.dialogue.id
      |> Library.get_dialogue!()
      |> Repo.preload(lines: [phrase: :translations])

    socket =
      socket
      |> assign(dialogue: dialogue)
      |> assign_dialogue(dialogue)

    {:noreply, socket}
  end

  def handle_event("validate", %{"dialogue" => dialogue_params}, socket) do
    case Library.update_dialogue(socket.assigns.dialogue, dialogue_params) do
      {:ok, dialogue} ->
        socket =
          socket
          |> assign_dialogue(dialogue, dialogue_params)
          |> assign_lines(dialogue)
          |> put_flash(:dev, "Successfully Created Dialogue")

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign_dialogue(changeset)
          |> notify_dialogue_subscribers(changeset)
          |> put_flash(:dev, "Error Updating Dialogue")

        {:noreply, socket}
    end
  end

  defp notify_dialogue_subscribers(socket, changeset) do
    topic = "dialogue:#{socket.assigns.dialogue.id}"
    Phoenix.PubSub.broadcast(Phrasing.PubSub, topic, {:dialogue_validate, :dialogue, changeset})

    socket
  end

  defp assign_dialogue(socket, %Ecto.Changeset{} = changeset) do
    socket
    |> assign(changeset: changeset)
    |> assign(dialogue: changeset.data.dialogue)
    |> assign_languages()
  end

  defp assign_dialogue(socket, %Library.Dialogue{} = dialogue) do
    changeset =
      if socket.assigns[:changeset] do
        Library.change_dialogue(dialogue, %{
          "translation_language_id" =>
            get_change(socket.assigns.changeset, :translation_language_id)
            |> IO.inspect(label: :changeme)
        })
      else
        Library.change_dialogue(dialogue, %{})
      end

    socket
    |> assign(changeset: changeset)
    |> assign(dialogue: dialogue)
    |> assign_languages()
  end

  defp assign_dialogue(socket, %Library.Dialogue{} = dialogue, params) do
    changeset = Library.change_dialogue(dialogue, params)

    socket
    |> assign(dialogue: dialogue)
    |> assign(changeset: changeset)
    |> notify_dialogue_subscribers(changeset)
    |> assign_languages()
  end

  defp assign_lines(socket, %Library.Dialogue{} = dialogue) do
    current_lines =
      dialogue.lines
      |> Enum.sort_by(& &1.position)
      |> Enum.map(fn line ->
        %{
          id: line.id,
          source: translation_for_line(line, socket.assigns.source_language),
          translation: translation_for_line(line, socket.assigns.translation_language)
        }
      end)

    max =
      (dialogue.lines ++ [%Library.DialogueLine{position: 1}])
      |> Enum.max_by(& &1.position)

    next_line = %{
      id: "n",
      source: translation_for_line(nil, socket.assigns.source_language),
      translation: translation_for_line(nil, socket.assigns.translation_language)
    }

    socket
    |> assign(lines: current_lines ++ next_line)
    |> assign(max_position: max.position)
  end

  defp assign_languages(socket) do
    source_language =
      socket.assigns.changeset
      |> get_field(:source_language_id)
      |> language_by_id(socket)

    translation_language =
      socket.assigns.changeset
      |> get_field(:translation_language_id)
      |> language_by_id(socket)

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

  defp language_by_id(id, socket) do
    socket.assigns.languages
    |> Enum.find(nil, &(&1.id == id))
  end

  defp translation_for_line(line, nil) do
    Dict.change_translation(%Dict.Translation{})
  end

  defp translation_for_line(nil, language) do
    nil
  end

  defp translation_for_line(line, language) do
    line.phrase.translations
    |> Enum.find(new_translation(line, language), &(&1.language_id == language.id))
    |> Dict.change_translation()
  end

  defp new_translation(line, language) do
    %Dict.Translation{
      line_id: line.id,
      language_id: language.id
    }
  end
end
