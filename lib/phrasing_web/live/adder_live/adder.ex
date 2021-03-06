defmodule PhrasingWeb.AdderLive.Adder do
  use Phoenix.LiveView

  alias Ecto.Changeset
  alias Phrasing.Dict
  alias Phrasing.Dict.Phrase
  alias Phrasing.Repo
  alias PhrasingWeb.AdderView

  @defaults %{
    left: "_phrase.html",
    open: false,
    right: "_select.html",
    select_language: false,
    target_lang: "en",
  }

  def new_changeset(nil), do: Dict.change_phrase(%Phrase{})
  def new_changeset(user_id) do
    last_phrase = Dict.get_last_phrase_for_user(user_id) || %Phrase{}
    translation_id = last_phrase.translations
      |> Map.keys
      |> random_or_nil

    %Phrase{translation_id: translation_id}
    |> Repo.preload(:cards)
    |> Dict.change_phrase()
  end

  def update_changeset(changeset, [_phrase, field], phrase) do
    value = phrase[field]
    Changeset.put_change(changeset, String.to_atom(field), value)
  end
  def update_changeset(changeset, [_phrase, "translations", _lang], phrase) do
    value = phrase["translations"]
    Changeset.put_change(changeset, :translations, value)
  end
  def update_changeset(changeset, [_phrase, "cards", _field], phrase) do
    card_params = phrase["cards"]
                  |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)

    Changeset.put_assoc(changeset, :cards, card_params)
  end
  def update_changeset(changeset, [_phrase, "entry", _field], phrase) do
    entry_params = phrase["entry"]
                  |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)

    Changeset.put_assoc(changeset, :entry, entry_params)
  end
  def update_changeset(changeset, target, _phrase) do
    changeset
  end

  def mount(session, socket) do
    changeset = new_changeset(session["current_user_id"])
    languages = Dict.list_languages()
    source_lang = Changeset.get_field(changeset, :lang)

    {:ok,
     assign(socket, Map.merge(@defaults, %{
       changeset: changeset,
       languages: languages,
       source_lang: source_lang,
       user_id: session["current_user_id"]
     }))}
  end

  def render(assigns) do
    AdderView.render("adder.html", assigns)
  end

  def handle_event("open", _params, socket) do
    {:noreply, assign(socket, open: true, changeset: new_changeset(socket.assigns.user_id))}
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
    case Dict.create_phrase_from_adder(Map.put(phrase_params, "user_id", socket.assigns.user_id)) do
      {:ok, _phrase} ->
        Dict.notify_dict_subscribers({:ok, nil}, :phrase_input)
        {:noreply, assign(socket, open: false, changeset: new_changeset(socket.assigns.user_id))}
      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp random_or_nil(list) do
    try do
      Enum.empty(list)
    rescue
      _ -> nil
    end
  end
end
