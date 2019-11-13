defmodule Phrasing.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :hint, :text
      add :mnem, :text
      add :phrase_id, references(:phrases, on_delete: :nothing)

      timestamps()
    end

    create index(:cards, [:phrase_id])
  end
end
