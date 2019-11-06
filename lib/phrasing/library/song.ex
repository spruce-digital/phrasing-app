defmodule Phrasing.Library.Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :body, :string
    field :lang, :string
    field :title, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:lang, :body, :url])
    |> validate_required([:lang, :body, :url])
  end
end
