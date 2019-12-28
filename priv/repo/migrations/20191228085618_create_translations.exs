defmodule Phrasing.Repo.Migrations.CreateTranslations do
  use Ecto.Migration

  def change do
    create table(:translations) do
      add :text, :string
      add :source, :boolean, default: false, null: false
      add :phrase_id, references(:phrases, on_delete: :nothing)
      add :language_id, references(:languages, on_delete: :nothing)

      timestamps()
    end

    alter table(:phrases) do
      remove :translations, :map
      remove :language_id, references(:languages, on_delete: :nothing)
    end

    create index(:translations, [:phrase_id])
    create index(:translations, [:language_id])
  end
end
