defmodule Phrasing.Library.Dialogue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dialogues" do
    field :title, :string
    field :author_id, :id

    timestamps()
  end

  @doc false
  def changeset(dialogue, attrs) do
    dialogue
    |> cast(attrs, [:title, :author_id])
    |> validate_required([:title, :author_id])
  end
end
