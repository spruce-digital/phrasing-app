defmodule Phrasing.Dict.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :root, :string
    field :tags, {:map, {:array, :string}}
    belongs_to :phrase, Phrasing.Dict.Phrase

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:root, :tags])
    |> validate_required([:root, :tags])
  end
end
