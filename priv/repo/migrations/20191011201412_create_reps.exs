defmodule Phrasing.Repo.Migrations.CreateReps do
  use Ecto.Migration

  def change do
    create table(:reps) do
      add :due_date, :date
      add :ease, :float
      add :interval, :integer
      add :iteration, :integer
      add :overdue, :integer
      add :score, :integer
      add :card_id, references(:cards, on_delete: :nothing)
      add :prev_rep_id, references(:reps, on_delete: :nothing)

      timestamps()
    end

    create index(:reps, [:card_id])
    create index(:reps, [:prev_rep_id])
  end
end
