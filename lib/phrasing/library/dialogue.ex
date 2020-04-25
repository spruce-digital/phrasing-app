defmodule Phrasing.Library.Dialogue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dialogues" do
    field :title, :string
    field :author_id, :id
    field :translation_language_id, :id, virtual: true
    field :source_language_id, :id

    has_many :lines, Phrasing.Library.DialogueLine
    has_one :source_language, Phrasing.Dict.Language

    many_to_many :phrases, Phrasing.Dict.Phrase,
      join_through: "dialogue_lines",
      on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(dialogue, attrs) do
    dialogue
    |> cast(attrs, [:title, :author_id, :source_language_id, :translation_language_id])
    |> validate_required([:title, :author_id])
  end
end
