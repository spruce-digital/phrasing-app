defmodule Phrasing.Dict.Phrase do
  use Ecto.Schema
  import Ecto.Changeset

  schema "phrases" do
    field :active, :boolean
    field :translations, {:map, {:array, :string}}, default: %{}
    field :translation_id, :id, virtual: true
    belongs_to :user, Phrasing.Accounts.User
    belongs_to :language, Phrasing.Dict.Language
    has_many :cards, Phrasing.SRS.Card
    has_one :entry, Phrasing.Dict.Entry

    timestamps()
  end

  @doc false
  def changeset(phrase, attrs) do
    phrase
    |> cast(attrs, [:translations, :language_id, :user_id])
    |> cast_assoc(:cards)
    |> validate_required([:translations, :language_id, :user_id])
  end

  @doc false
  def adder_changeset(phrase, attrs) do
    attrs = filter_empty_translations(attrs)

    changeset = phrase
    |> cast(attrs, [:translations, :language_id, :user_id])
    |> cast_assoc_when_present(:cards, attrs["card"])
    |> cast_assoc_when_present(:entry, attrs["entry"])
    |> validate_required([:translations, :language_id, :user_id])

    changeset
  end

  @doc false
  def search_changeset(phrase, attrs) do
    attrs = attrs
          |> Map.put("translations", build_translations_from_search(attrs))
          |> Map.put("language_id", attrs["source_language"])
          |> filter_empty_translations()

    phrase
    |> cast(attrs, [:translations, :language_id, :user_id])
    |> validate_required([:translations, :language_id, :user_id])
  end

  def build_translations_from_search(attrs) do
    languages = [attrs["source_language"]] ++ attrs["translation_languages"]
    translation_strings = [attrs["source"]] ++ attrs["translations"]

    Enum.reduce(Enum.with_index(languages), %{}, fn ({language, index}, acc) ->
      next_translation = Enum.at translation_strings, index

      translation_list = case acc[language] do
        nil      -> [next_translation]
        existing -> existing ++ [next_translation]
      end

      Map.put acc, language, translation_list
    end)
  end

  def cast_assoc_when_present(changeset, field, value) do
    if is_empty_map(value), do: changeset, else: cast_assoc(changeset, field)
  end

  def is_empty_map(nil), do: true
  def is_empty_map(map) do
    string = map
    |> Map.values()
    |> Enum.join()
    |> String.trim()

    string == ""
  end

  def filter_empty_translations(attrs) do
    Map.put(attrs, "translations", Enum.reduce(attrs["translations"], %{}, fn {lang, body}, acc ->
      Map.put(acc, lang, Enum.filter(body, fn t -> t != "" end))
    end))
  end

  def print_translation(phrase) do
    "#{phrase.lang}: #{phrase.translations[phrase.lang]}"
  end
  def print_translation(phrase, lang) do
    "#{lang}: #{phrase.translations[lang]}"
  end
end
