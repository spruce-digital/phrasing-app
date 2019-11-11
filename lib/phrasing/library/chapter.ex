defmodule Phrasing.Library.Chapter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chapters" do
    field :body, :map
    belongs_to :book, Phrasing.Library.Book

    timestamps()
  end

  @doc false
  def changeset(chapter, attrs) do
    chapter
    |> cast(attrs, [:body, :book_id])
    |> validate_required([:body, :book_id])
  end
end
