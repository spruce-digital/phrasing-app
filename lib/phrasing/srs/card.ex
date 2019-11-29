defmodule Phrasing.SRS.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :hint, :string
    field :lang, :string
    field :mnem, :string
    field :translation, :string

    belongs_to :phrase, Phrasing.Dict.Phrase
    belongs_to :prev_rep, Phrasing.SRS.Rep
    has_many :reps, Phrasing.SRS.Rep

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:phrase_id, :prev_rep_id, :hint, :mnem, :lang, :translation])
    |> validate_required([:lang, :translation])
  end

  def source(card) do
    card.phrase.translations[card.lang]
  end

  def target(card) do
    card.phrase.translations[card.translation]
  end
end
