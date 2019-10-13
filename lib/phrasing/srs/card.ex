defmodule Phrasing.SRS.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    belongs_to :prev_rep, Phrasing.SRS.Rep
    belongs_to :phrase, Phrasing.Dict.Phrase
    has_many :reps, Phrasing.SRS.Rep

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:phrase_id, :prev_rep_id])
    |> validate_required([:phrase_id])
  end
end
