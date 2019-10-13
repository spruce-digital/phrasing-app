defmodule Phrasing.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :phrase_id, references(:phrases, on_delete: :nothing)

      timestamps()
    end

    create index(:cards, [:phrase_id])
  end
end
