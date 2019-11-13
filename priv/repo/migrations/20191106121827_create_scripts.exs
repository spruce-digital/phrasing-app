defmodule Phrasing.Repo.Migrations.CreateScripts do
  use Ecto.Migration

  def change do
    create table(:scripts) do
      add :body, :map
      add :lang, :string
      add :title, :string

      timestamps()
    end

  end
end
