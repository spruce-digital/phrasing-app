defmodule Phrasing.Dict.Phrase do
  use Ecto.Schema
  import Ecto.Changeset

  schema "phrases" do
    field :english, :string
    field :source, :string
    field :lang, :string

    timestamps()
  end

  @doc false
  def changeset(phrase, attrs) do
    phrase
    |> cast(attrs, [:source, :english])
    |> validate_required([:source, :english])
  end
end
