defmodule Phrasing.Dict.Phrase do
  use Ecto.Schema
  import Ecto.Changeset

  alias Phrasing.Dict.Translation

  schema "phrases" do
    field :active, :boolean, default: true
    field :translation_id, :id, virtual: true
    belongs_to :user, Phrasing.Accounts.User
    has_many :translations, Phrasing.Dict.Translation, on_replace: :delete
    has_one :entry, Phrasing.Dict.Entry

    timestamps()
  end

  @doc false
  def changeset(phrase, attrs) do
    attrs =
      attrs
      |> filter_empty_translations()

    phrase
    |> cast(attrs, [:user_id])
    |> cast_assoc(:cards)
    |> cast_assoc(:translations)
    |> validate_required([:user_id])
  end

  @doc "A changeset that eschuwes translations"
  def phrase_changeset(phrase, attrs) do
    phrase
    |> cast(attrs, [:user_id])
    |> cast_assoc(:cards)
    |> validate_required([:user_id])
  end

  @doc "A changset that validates translations as well, without :phrase_id"
  def dry_changeset(phrase, attrs) do
    attrs =
      attrs
      |> filter_empty_translations()

    phrase
    |> cast(attrs, [:user_id])
    |> cast_assoc(:cards)
    |> cast_assoc(:translations, with: &Phrasing.Dict.Translation.dry_changeset/2)
    |> validate_required([:user_id])
  end

  @doc false
  def translations_changeset(phrase, attrs) do
    attrs =
      attrs
      |> filter_empty_translations()
      |> add_phrase_id(phrase.id)

    changeset =
      phrase
      |> Phrasing.Repo.preload(:translations)
      |> cast(attrs, [])
      |> cast_assoc(:translations)
  end

  @doc false
  def adder_changeset(phrase, attrs) do
    attrs = filter_empty_translations(attrs)

    changeset =
      phrase
      |> cast(attrs, [:user_id])
      |> cast_assoc_when_present(:cards, attrs["card"])
      |> cast_assoc_when_present(:entry, attrs["entry"])
      |> validate_required([:translations, :user_id])

    changeset
  end

  def cast_assoc_when_present(changeset, field, value) do
    if is_empty_map(value), do: changeset, else: cast_assoc(changeset, field)
  end

  def is_empty_map(nil), do: true

  def is_empty_map(map) do
    string =
      map
      |> Map.values()
      |> Enum.join()
      |> String.trim()

    string == ""
  end

  def filter_empty_translations(attrs) do
    if attrs["translations"] do
      translations =
        attrs
        |> Access.get("translations", %{})
        |> Enum.reject(fn {_key, t} ->
          Access.get(t, "text", "") == ""
        end)
        |> Enum.into(%{})

      Map.put(attrs, "translations", translations)
    else
      attrs
    end
  end

  def add_phrase_id(attrs, phrase_id) do
    if attrs["translations"] do
      translations =
        attrs
        |> Access.get("translations", %{})
        |> Enum.map(fn {key, t} ->
          {key, Map.put(t, "phrase_id", phrase_id)}
        end)
        |> Enum.into(%{})

      Map.put(attrs, "translations", translations)
    else
      attrs
    end
  end

  def print_translation(phrase) do
    "#{phrase.lang}: #{List.first(phrase.translations[phrase.lang])}"
  end

  def print_translation(phrase, lang) do
    "#{lang}: #{List.first(phrase.translations[lang])}"
  end

  def translation_list(phrase) do
    phrase.translations
    |> Enum.sort_by(& &1.source)
    |> Enum.reverse()
  end
end
