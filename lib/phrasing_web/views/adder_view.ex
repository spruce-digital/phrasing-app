defmodule PhrasingWeb.AdderView do
  use PhrasingWeb, :view
  import Phrasing.Dict, only: [language_name: 1]
  import PhrasingWeb.UIView, only: [label_lang: 3, label_lang: 4, textarea_lang: 3, hidden_input_lang: 3, text_input_lang: 3]

  alias Phrasing.Dict.Phrase
  alias Ecto.Changeset

  def language_class language, changeset do
    value = Access.get(language, :value)
    current = Changeset.get_field(changeset, :lang)

    if value == current do
      "language language-selected"
    else
      "language"
    end
  end

  def interpretations do
    [:translation, :literal, :translit]
  end

  def entry_placeholder changeset do
    translations = Changeset.get_field(changeset, :translations)
    lang = Changeset.get_field(changeset, :lang)

    IO.inspect(changeset)

    translations[lang]
  end
end
