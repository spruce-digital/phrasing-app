defmodule Phrasing.Library.Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :body, {:map, :string}
    field :title, :string
    field :url, :string
    field :translations, {:array, :string}, virtual: true
    belongs_to :language, Phrasing.Dict.Language

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:body, :url, :title, :lang])
    |> validate_required([:body, :title, :lang])
  end
end
