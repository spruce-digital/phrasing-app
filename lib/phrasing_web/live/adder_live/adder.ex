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
    |> Dict.change_phrase()
  end

  def update_changeset(changeset, [_phrase, field], phrase) do
    value = phrase[field]
    Changeset.put_change(changeset, String.to_atom(field), value)
  end

  def update_changeset(changeset, _target, _phrase) do
    changeset
  end

  def mount(_session, socket) do
    changeset = new_changeset()
    languages = Phrase.languages()
    source_lang = Changeset.get_field(changeset, :lang)

    {:ok,
     assign(socket,
       changeset: changeset,
       languages: languages,
       open: true,
       select_language: false,
       source_lang: source_lang,
       target_lang: "en",
       left: "_phrase.html",
       right: "_select.html",
     )}
  end

  def render(assigns) do
    AdderView.render("adder.html", assigns)
  end

  def handle_event("open", _params, socket) do
    {:noreply, assign(socket, open: true, changeset: new_changeset())}
  end

  def handle_event("close", _params, socket) do
    Dict.notify_dict_subscribers({:ok, nil}, :phrase_input)
    {:noreply, assign(socket, open: false, select_language: false)}
  end

  def handle_event("change_right", %{"partial" => partial}, socket) do
    {:noreply, assign(socket, right: partial)}
  end

  def handle_event("change_left", %{"partial" => partial}, socket) do
    {:noreply, assign(socket, left: partial)}
  end

  def handle_event("select_language", %{"lang" => lang}, socket) do
    if socket.assigns.select_language == "source" do
      changeset = Changeset.put_change(socket.assigns.changeset, :lang, lang)
      Dict.notify_dict_subscribers({:ok, changeset}, :phrase_input)
      {:noreply, assign(socket, select_language: false, changeset: changeset, source_lang: lang)}
    else
      {:noreply, assign(socket, select_language: false, target_lang: lang)}
    end
  end

  def handle_event("select_language:" <> target, _params, socket) do
    {:noreply, assign(socket, select_language: target)}
  end

  def handle_event("change_interpretation", %{"interpretation" => interp}, socket) do
    {:noreply, assign(socket, interpretation: String.to_atom(interp))}
  end

  def handle_event("update", %{"_target" => target, "phrase" => phrase}, socket) do
    changeset = update_changeset(socket.assigns.changeset, target, phrase)
    Dict.notify_dict_subscribers({:ok, changeset}, :phrase_input)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("submit", %{"phrase" => phrase_params}, socket) do
    with {:ok, phrase} <- Dict.create_phrase(phrase_params),
         {:ok, card} <- SRS.score_card({:ok, phrase.card}) do
      Dict.notify_dict_subscribers({:ok, nil}, :phrase_input)
      {:noreply, assign(socket, open: false, changeset: new_changeset())}
    end
  end
end
