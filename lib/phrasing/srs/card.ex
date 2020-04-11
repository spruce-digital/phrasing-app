defmodule Phrasing.SRS.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :active, :boolean, default: true
    field :hint, :string
    field :mnem, :string

    belongs_to :language, Phrasing.Dict.Language
    belongs_to :prev_rep, Phrasing.SRS.Rep
    belongs_to :translation, Phrasing.Dict.Language
    belongs_to :user, Phrasing.Account.User
    has_many :reps, Phrasing.SRS.Rep

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:translation_id, :user_id, :prev_rep_id, :hint, :mnem, :active])
    |> validate_required([:translation_id, :user_id])
  end

  def source(card) do
    card.phrase.translations[card.lang]
  end

  def target(card) do
    card.phrase.translations[card.translation]
  end
end
