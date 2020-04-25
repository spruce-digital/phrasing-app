defmodule Phrasing.Repo.Migrations.AddSourceLanguageToDialogues do
  use Ecto.Migration

  def change do
    alter table(:dialogues) do
      add(:source_language_id, references(:languages, on_delete: :nothing))
    end

    create(index(:dialogues, [:source_language_id]))
  end
end
