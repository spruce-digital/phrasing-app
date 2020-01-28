defmodule Phrasing.Repo.Migrations.AddFlagToLanguage do
  use Ecto.Migration

  def change do
    alter table(:languages) do
      add :flag_code, :string
    end
  end
end
