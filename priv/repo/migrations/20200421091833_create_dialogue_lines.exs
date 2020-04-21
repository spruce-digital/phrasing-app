defmodule Phrasing.Repo.Migrations.CreateDialogueLines do
  use Ecto.Migration

  def change do
    create table(:dialogue_lines) do
      add :position, :integer
      add :dialogue_id, references(:dialogues, on_delete: :nothing)
      add :phrase_id, references(:phrases, on_delete: :nothing)

      timestamps()
    end

    create index(:dialogue_lines, [:dialogue_id])
    create index(:dialogue_lines, [:phrase_id])
  end
end
