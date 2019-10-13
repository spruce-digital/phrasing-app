defmodule Phrasing.Repo.Migrations.AddLastRepToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :prev_rep_id, references(:reps, on_delete: :nothing)
    end

    create index(:cards, [:prev_rep_id])
  end
end
