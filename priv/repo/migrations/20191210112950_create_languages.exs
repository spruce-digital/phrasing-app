defmodule Phrasing.Repo.Migrations.CreateLanguages do
  use Ecto.Migration

  def change do
    create table(:languages) do
      add :name, :string
      add :code, :string
      add :script, :string

      timestamps()
    end

    alter table(:entries) do
      remove :lang, :string
      add :language_id, references(:languages, on_delete: :nothing)
    end

    alter table(:phrases) do
      remove :lang, :text
      add :language_id, references(:languages, on_delete: :nothing)
    end

    alter table(:cards) do
      remove :lang, :text
      remove :translation, :text
      add :language_id, references(:languages, on_delete: :nothing)
      add :translation_id, references(:languages, on_delete: :nothing)
    end

    alter table(:songs) do
      remove :lang, :string
      add :language_id, references(:languages, on_delete: :nothing)
    end

    alter table(:books) do
      remove :lang, :string
      add :language_id, references(:languages, on_delete: :nothing)
    end

    alter table(:scripts) do
      remove :lang, :string
      add :language_id, references(:languages, on_delete: :nothing)
    end

    create index(:entries, [:language_id])
    create index(:phrases, [:language_id])
    create index(:cards, [:language_id, :translation_id])
    create index(:songs, [:language_id])
    create index(:books, [:language_id])
    create index(:scripts, [:language_id])
  end
end
