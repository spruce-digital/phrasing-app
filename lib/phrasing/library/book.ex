defmodule Phrasing.Library.Book do
  use Ecto.Schema
  import Ecto.Changeset
  alias Phrasing.Library.Chapter

  schema "books" do
    field :lang, :string
    field :title, :string
    field :translations, {:array, :string}, virtual: true
    has_many :chapters, Phrasing.Library.Chapter

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:lang, :title])
    |> cast_assoc(:chapters, with: &Chapter.changeset/2)
    |> validate_required([:lang, :title])
  end
end
