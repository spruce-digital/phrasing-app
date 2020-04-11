defmodule Phrasing.Repo.Migrations.UpdateCardRelations do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      remove(:phrase_id, references(:phrases, on_delete: :nothing))
      add(:user_id, references(:users))
    end

    create(index(:cards, [:user_id]))
  end
end
