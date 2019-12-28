defmodule Phrasing.Repo.Migrations.MoveScripts do
  use Ecto.Migration

  def change do
    alter table(:languages) do
      remove :script, :string
    end

    alter table(:translations) do
      add :script, :text
    end
  end
end
