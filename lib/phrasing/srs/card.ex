defmodule Phrasing.SRS.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :phrase_id, :id

    has_many :reps, Phrasing.SRS.Rep

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:phrase_id])
    # |> validate_required([:phrase_id])
  end
end
