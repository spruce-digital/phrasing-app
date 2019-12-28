defmodule Phrasing.Dict.Phrase do
  use Ecto.Schema
  import Ecto.Changeset

  alias Phrasing.Dict.Translation

  schema "phrases" do
    field :active, :boolean
    field :translation_id, :id, virtual: true
    belongs_to :user, Phrasing.Accounts.User
    has_many :cards, Phrasing.SRS.Card
    has_many :translations, Phrasing.Dict.Translation
    has_one :entry, Phrasing.Dict.Entry

    timestamps()
  end

  @doc false
  def changeset(phrase, attrs) do
    IO.inspect attrs, label: "before"
    attrs = filter_empty_translations(attrs)
    IO.inspect attrs, label: "after"


    phrase
    |> cast(attrs, [:user_id])
    |> cast_assoc(:cards)
    |> cast_assoc(:translations)
    |> validate_required([:user_id])
  end

  @doc false
  def adder_changeset(phrase, attrs) do
    attrs = filter_empty_translations(attrs)

    changeset = phrase
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
    string = map
    |> Map.values()
    |> Enum.join()
    |> String.trim()

    string == ""
  end

# alias Dict
#
# phrase_params = %{
#   "source" => "",
#   "translations" => %{
#     "0" => %{"text" => "hello"},
#     "1" => %{"text" => "world"},
#     "2" => %{"text" => ""}
#   },
#   "user_id" => "1"
# }
#
# Dict.change_phrase(%Dict.Phrase{}, phrase_params)

  def filter_empty_translations(attrs) do
    if attrs["translations"] do
      translations = attrs
      |> Access.get("translations", %{})
      |> Map.values()
      |> Enum.reject(fn t ->
           Access.get(t, "langauge_id", "") == "" && Access.get(t, "text", "") == ""
         end)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {translation, index}, acc ->
           Map.put(acc, to_string(index), translation)
         end)

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
    |> Enum.sort_by(&(&1.source))
    |> Enum.reverse()
  end
end
