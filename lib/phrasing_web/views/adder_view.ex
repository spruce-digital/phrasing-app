defmodule PhrasingWeb.AdderView do
  use PhrasingWeb, :view

  alias Phrasing.Dict.Phrase
  alias Ecto.Changeset

  def language_name language_code do
    Phrase.languages
    |> Enum.find(fn x -> x[:value] == language_code end)
    |> Access.get(:key)
  end

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
    [:english, :literal, :translit]
  end
end
