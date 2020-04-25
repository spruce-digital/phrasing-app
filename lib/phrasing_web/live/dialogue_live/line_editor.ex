defmodule PhrasingWeb.DialogueLive.LineEditor do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form
  import Ecto.Changeset

  alias Phrasing.Dict
  alias Phrasing.Library
  alias PhrasingWeb.UILive.Field

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_line(assigns[:line] || assigns[:dialogue])

    {:ok, socket}
  end

  def handle_event("validate", %{"dialogue_line" => line_params}, socket) do
    changeset = Library.change_dialogue_line(socket.assigns.changeset.data, line_params)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("create", %{"dialogue_line" => line_params}, socket) do
    case Library.create_dialogue_line(line_params,
           user_id: socket.assigns.user_id,
           language_id: socket.assigns.language.id
         ) do
      {:ok, line} ->
        {:noreply, assign_line(socket, socket.assigns.dialogue)}

      {:error, _error} ->
        {:noreply, socket}
    end
  end

  def handle_event("update", %{"dialogue_line" => line_params}, socket) do
    if socket.assigns.translation.id do
      Library.update_dialogue_line(socket.assigns.line, line_params,
        translation_id: socket.assigns.translation.id
      )
    else
      Library.update_dialogue_line(socket.assigns.line, line_params,
        language_id: socket.assigns.language.id
      )
    end

    {:noreply, socket}
  end

  defp assign_line(socket, %Library.DialogueLine{} = line) do
    translation =
      line.phrase.translations
      |> Enum.find(%Dict.Translation{text: ""}, &(&1.language_id == socket.assigns.language.id))

    line_params = %{translation: translation.text}

    socket
    |> assign(line: line)
    |> assign(translation: translation)
    |> assign_id(language_id: socket.assigns.language.id, line_id: line.id)
    |> assign(submit_action: :update)
    |> assign(changeset: Library.change_dialogue_line(line, line_params))
  end

  defp assign_line(socket, %Library.Dialogue{} = dialogue) do
    line = %Library.DialogueLine{dialogue_id: dialogue.id, position: socket.assigns.position}

    socket
    |> assign(line: line)
    |> assign(changeset: Library.change_dialogue_line(line))
    |> assign(submit_action: :create)
    |> assign_id(language_id: socket.assigns.language.id, line_id: "n")
  end

  defp assign_id(socket, language_id: language_id, line_id: line_id) do
    assign(socket, id: "line_#{line_id}_#{language_id}_translation")
  end
end
