defmodule Phrasing.Repo.Migrations.AddUserToPhrasesAndEntries do
  use Ecto.Migration

  def change do
    alter table("phrases") do
      add :user_id, references(:users, on_delete: :nothing)
    end

    alter table("entries") do
      add :user_id, references(:users, on_delete: :nothing)
    end
  end
end
