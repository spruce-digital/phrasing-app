defmodule PhrasingWeb.PhraseController do
  use PhrasingWeb, :controller

  alias Phrasing.Dict
  alias Phrasing.Dict.Phrase
  alias PhrasingWeb.PhraseLive.Index

  def index(conn, _params) do
    # phrases = Dict.list_phrases()
    # render(conn, "index.html", phrases: phrases)

    live_render(conn, Index, session: %{})
  end

  def new(conn, _params) do
    changeset = Dict.change_phrase(%Phrase{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"phrase" => phrase_params}) do
    case Dict.create_phrase(phrase_params) do
      {:ok, phrase} ->
        conn
        |> put_flash(:info, "Phrase created successfully.")
        |> redirect(to: Routes.phrase_path(conn, :show, phrase))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    phrase = Dict.get_phrase!(id)
    render(conn, "show.html", phrase: phrase)
  end

  def edit(conn, %{"id" => id}) do
    phrase = Dict.get_phrase!(id)
    changeset = Dict.change_phrase(phrase)
    render(conn, "edit.html", phrase: phrase, changeset: changeset)
  end

  def update(conn, %{"id" => id, "phrase" => phrase_params}) do
    phrase = Dict.get_phrase!(id)

    case Dict.update_phrase(phrase, phrase_params) do
      {:ok, phrase} ->
        conn
        |> put_flash(:info, "Phrase updated successfully.")
        |> redirect(to: Routes.phrase_path(conn, :show, phrase))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", phrase: phrase, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    phrase = Dict.get_phrase!(id)
    {:ok, _phrase} = Dict.delete_phrase(phrase)

    conn
    |> put_flash(:info, "Phrase deleted successfully.")
    |> redirect(to: Routes.phrase_path(conn, :index))
  end
end
