defmodule Phrasing.Library.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :body, :string
    field :lang, :string
    field :title, :string
    field :translations, {:array, :string}, virtual: true
    has_many :chapters, Phrasing.Library.Chapter

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:lang, :body, :title])
    |> validate_required([:lang, :body, :title])
  end
end
