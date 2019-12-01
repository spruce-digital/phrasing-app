defmodule Phrasing.Repo.Migrations.AddUserToPhrases do
  use Ecto.Migration

  def change do
    alter table(:phrases) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:phrases, [:user_id])
  end
end
