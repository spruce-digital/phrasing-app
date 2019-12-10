defmodule Phrasing.Library.Script do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scripts" do
    field :body, {:map, :string}
    field :title, :string
    field :translations, {:array, :string}, virtual: true
    belongs_to :language, Phrasing.Dict.Language

    timestamps()
  end

  @doc false
  def changeset(script, attrs) do
    script
    |> cast(attrs, [:lang, :body, :title])
    |> validate_required([:lang, :body, :title])
  end
end
