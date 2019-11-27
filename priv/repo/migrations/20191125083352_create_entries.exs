defmodule Phrasing.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :lang, :string
      add :phrase_id, references(:phrases, on_delete: :nothing)
      add :root, :string
      add :tags, :map

      timestamps()
    end

  end
end
