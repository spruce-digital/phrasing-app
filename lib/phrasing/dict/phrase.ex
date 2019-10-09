defmodule Phrasing.Dict.Phrase do
  use Ecto.Schema
  import Ecto.Changeset

  schema "phrases" do
    field :english, :string
    field :source, :string
    field :lang, :string
    field :dialect, :string

    timestamps()
  end

  @doc false
  def changeset(phrase, attrs) do
    phrase
    |> cast(attrs, [:source, :english, :lang, :dialect])
    |> validate_required([:source, :english, :lang])
  end
end
