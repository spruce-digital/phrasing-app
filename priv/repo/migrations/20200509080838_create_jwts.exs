defmodule Phrasing.Repo.Migrations.CreateJwts do
  use Ecto.Migration

  def change do
    create table(:jwts) do
      add :token, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:jwts, [:user_id])
  end
end
