defmodule Phrasing.Library.Journal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "journal" do
    field :body, :string
    field :lang, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(journal, attrs) do
    journal
    |> cast(attrs, [:lang, :body])
    |> validate_required([:lang, :body])
  end
end
