defmodule PhrasingWeb.AdderLive.Adder do
  use Phoenix.LiveView

  alias Phrasing.Dict
  alias Phrasing.Dict.Phrase
  alias PhrasingWeb.AdderView
  alias Ecto.Changeset

  def new_changeset() do
    Dict.change_phrase(%Phrase{lang: "nl"})
  end

  def mount(_session, socket) do
    changeset = new_changeset
    interpretation = :english
    languages = Phrase.languages

    {:ok, assign(socket, open: true, changeset: changeset,
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
    value = get_in phrase, tl(target)
    field = target
            |> List.last
            |> String.to_atom

    changeset = Changeset.put_change socket.assigns.changeset, field, value

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("submit", %{"phrase" => phrase}, socket) do
    IO.inspect phrase

    {:noreply, assign(socket, open: false, changeset: new_changeset)}
  end
end
