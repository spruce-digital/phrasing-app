defmodule PhrasingWeb.AdderLive.Adder do
  use Phoenix.LiveView

  alias Ecto.Changeset
  alias Phrasing.Dict
  alias Phrasing.Dict.Phrase
  alias Phrasing.Repo
  alias Phrasing.SRS
  alias PhrasingWeb.AdderView

  def new_changeset() do
    %Phrase{lang: "nl"}
    |> Repo.preload(:card)
    |> Dict.change_phrase
  end

  def update_changeset(changeset, [_phrase, field], phrase) do
    value = phrase[field]
    Changeset.put_change changeset, String.to_atom(field), value
  end
  def update_changeset(changeset, _target, _phrase) do
    changeset
  end

  def mount(_session, socket) do
    changeset = new_changeset()
    interpretation = :english
    languages = Phrase.languages

    {:ok, assign(socket, open: false, changeset: changeset,
      interpretation: interpretation, select_language: false,
      languages: languages)}
  end

  def render(assigns) do
    AdderView.render("adder.html", assigns)
  end

  def handle_event("open", _params, socket) do
    {:noreply, assign(socket, open: true)}
  end

  def handle_event("close", _params, socket) do
    {:noreply, assign(socket, open: false)}
  end

  def handle_event("select_language", %{"lang" => lang}, socket) do
    changeset = Changeset.put_change socket.assigns.changeset, :lang, lang
    {:noreply, assign(socket, select_language: false, changeset: changeset)}
  end
  def handle_event("select_language", _params, socket) do
    {:noreply, assign(socket, select_language: true)}
  end

  def handle_event("change_interpretation", %{"interpretation" => interp}, socket) do
    {:noreply, assign(socket, interpretation: String.to_atom(interp))}
  end

  def handle_event("update", %{"_target" => target, "phrase" => phrase}, socket) do
    changeset = update_changeset socket.assigns.changeset, target, phrase

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("submit", %{"phrase" => phrase_params}, socket) do
    with {:ok, phrase} <- Dict.create_phrase(phrase_params),
         {:ok, card}   <- SRS.score_card({:ok, phrase.card}) do
      {:noreply, assign(socket, open: false, changeset: new_changeset())}
    end
  end
end
