defmodule PhrasingWeb.PhraseLive.Edit do
  use Phoenix.LiveView

  alias Phrasing.Dict
  alias PhrasingWeb.PhraseView
  alias PhrasingWeb.Router.Helpers, as: Routes

  def mount(%{id: id}, socket) do
    phrase = Dict.get_phrase!(id)
    changeset = Dict.change_phrase(phrase)
    {:ok, assign(socket, phrase: phrase, changeset: changeset, id: id)}
  end

  def render(assigns) do
    PhraseView.render("edit.html", assigns)
  end

  def handle_event("update", %{"phrase" => phrase_params}, socket) do
    phrase = socket.assigns.phrase

    case Dict.update_phrase(phrase, phrase_params) do
      {:ok, phrase} ->
        {:stop,
         socket
         |> put_flash(:info, "Phrase updated successfully")
         |> redirect(to: Routes.phrase_path(socket, :show, phrase))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
