defmodule Phrasing.Repo.Migrations.CreateUserLanguages do
  use Ecto.Migration

  def change do
    create table(:user_languages) do
      add :language_id, references(:languages, on_delete: :nothing)
      add :level, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:user_languages, [:language_id])
    create index(:user_languages, [:user_id])
  end
end
