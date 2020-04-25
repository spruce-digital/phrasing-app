defmodule Phrasing.Library.DialogueLine do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dialogue_lines" do
    field :position, :integer
    field :translation, :string, virtual: true

    belongs_to :dialogue, Phrasing.Library.Dialogue
    belongs_to :phrase, Phrasing.Dict.Phrase

    timestamps()
  end

  @doc false
  def changeset(dialogue_line, attrs) do
    dialogue_line
    |> cast(attrs, [:position, :phrase_id, :dialogue_id])
    |> validate_required([:position])
  end
end
