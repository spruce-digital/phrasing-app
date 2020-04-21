defmodule Phrasing.Library.DialogueLine do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dialogue_lines" do
    field :position, :integer
    field :dialogue_id, :id
    field :phrase_id, :id

    timestamps()
  end

  @doc false
  def changeset(dialogue_line, attrs) do
    dialogue_line
    |> cast(attrs, [:position])
    |> validate_required([:position])
  end
end
