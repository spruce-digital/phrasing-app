defmodule Phrasing.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :root, :string
      add :tags, :map
      add :phrase_id, references(:phrases, on_delete: :nothing)

      timestamps()
    end

  end
end
