defmodule Phrasing.Library.Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :body, {:map, :string}
    field :lang, :string
    field :add_lang, :string, virtual: true
    field :title, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:body, :url, :title, :lang, :add_lang])
    |> validate_required([:body, :title])
  end
end
