defmodule Phrasing.Dict.Phrase do
  use Ecto.Schema
  import Ecto.Changeset

  schema "phrases" do
    field :active, :boolean
    field :translation_id, :id, virtual: true
    belongs_to :user, Phrasing.Accounts.User
    belongs_to :language, Phrasing.Dict.Language
    has_many :cards, Phrasing.SRS.Card
    has_one :entry, Phrasing.Dict.Entry

    embeds_many :translations, Translation do
      belongs_to :language, Phrasing.Dict.Language
      field :source, :boolean, default: false
      field :text, :string
    end

    timestamps()
  end

  @doc false
  def changeset(phrase, attrs) do
    phrase
    |> cast(attrs, [:language_id, :user_id])
    |> cast_assoc(:cards)
    |> validate_required([:translations, :language_id, :user_id])
  end

  @doc false
  def adder_changeset(phrase, attrs) do
    attrs = filter_empty_translations(attrs)

    changeset = phrase
    |> cast(attrs, [:language_id, :user_id])
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

    phrase
    |> cast(attrs, [:language_id, :user_id])
    |> cast_embed(:translations, with: &translation_changeset/2)
    |> validate_required([:translations, :language_id, :user_id])
  end

  def translation_changeset(schema, params) do
    schema
    |> cast(params, [:text, :language_id, :source])
  end

  def build_translations_from_search(attrs) do
    languages = [attrs["source_language"]] ++ attrs["translation_languages"]
    translation_strings = [attrs["source"]] ++ attrs["translations"]

    Enum.reduce(Enum.with_index(languages), [], fn ({language, index}, acc) ->
      text = Enum.at translation_strings, index

      acc ++ [%{"text" => text, "language_id" => language, "source" => index == 0}]
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
    "#{phrase.lang}: #{List.first(phrase.translations[phrase.lang])}"
  end
  def print_translation(phrase, lang) do
    "#{lang}: #{List.first(phrase.translations[lang])}"
  end

  def translation_list(phrase) do
    phrase.translations
    |> Enum.sort_by(&(&1.source))
    |> Enum.reverse()
  end
end
