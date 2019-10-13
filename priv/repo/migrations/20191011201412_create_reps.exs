defmodule Phrasing.Repo.Migrations.CreateReps do
  use Ecto.Migration

  def change do
    create table(:reps) do
      add :score, :integer
      add :overdue, :integer
      add :ease, :float
      add :interval, :integer
      add :due_date, :date
      add :card_id, references(:cards, on_delete: :nothing)
      add :last_rep_id, references(:reps, on_delete: :nothing)

      timestamps()
    end

    create index(:reps, [:card_id])
    create index(:reps, [:last_rep_id])
  end
end
