defmodule Phrasing.SRS.Rep do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reps" do
    field :due_date, :date
    field :ease, :float
    field :interval, :integer
    field :overdue, :integer
    field :score, :integer
    field :card_id, :id
    field :last_rep_id, :id

    belongs_to :card, Phrasing.SRS.Card
    belongs_to :last_rep, Phrasing.SRS.Rep
    has_one :next_rep, Phrasing.SRS.Rep, foreign_key: :last_rep_id

    timestamps()
  end

  @doc false
  def changeset(rep, attrs) do
    rep
    |> cast(attrs, [:score, :overdue, :ease, :interval, :due_date])
    |> validate_required([:score, :overdue, :ease, :interval, :due_date])
  end
end
