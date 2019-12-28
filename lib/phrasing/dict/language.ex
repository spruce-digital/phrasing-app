defmodule Phrasing.Dict.Language do
  use Ecto.Schema
  import Ecto.Changeset

  schema "languages" do
    field :code, :string
    field :name, :string
    has_many :entries, Phrasing.Dict.Entry
    has_many :cards, Phrasing.SRS.Card
    has_many :card_translations, Phrasing.SRS.Card, foreign_key: :translation_id
    has_many :songs, Phrasing.Library.Song
    has_many :books, Phrasing.Library.Book
    has_many :scripts, Phrasing.Library.Script

    timestamps()
  end

  @doc false
  def changeset(language, attrs) do
    language
    |> cast(attrs, [:name, :code])
    |> validate_required([:name, :code])
  end
end
