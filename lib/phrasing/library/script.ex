defmodule Phrasing.Library.Script do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scripts" do
    field :body, {:map, :string}
    field :lang, :string
    field :title, :string
    field :translations, {:array, :string}, virtual: true

    timestamps()
  end

  @doc false
  def changeset(script, attrs) do
    script
    |> cast(attrs, [:lang, :body, :title])
    |> validate_required([:lang, :body, :title])
  end
end
