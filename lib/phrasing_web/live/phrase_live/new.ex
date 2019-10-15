defmodule PhrasingWeb.PhraseLive.New do
  use Phoenix.LiveView

  alias Phrasing.Dict
  alias Phrasing.Dict.Phrase
  alias Phrasing.SRS
  alias PhrasingWeb.PhraseView
  alias PhrasingWeb.Router.Helpers, as: Routes

  def mount(_session, socket) do
    changeset = Dict.change_phrase(%Phrase{})
    {:ok, assign(socket, changeset: changeset)}
  end

  def render(assigns) do
    PhraseView.render("new.html", assigns)
  end

  def handle_event("create", %{"phrase" => phrase_params}, socket) do
    case Dict.create_phrase(phrase_params) do
      {:ok, phrase} ->
        SRS.create_card %{phrase: phrase}
        {:stop,
          socket
          |> put_flash(:info, "Phrase created successfully.")
          |> redirect(to: Routes.phrase_path(socket, :show, phrase))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
