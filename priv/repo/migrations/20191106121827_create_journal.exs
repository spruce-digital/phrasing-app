defmodule Phrasing.Repo.Migrations.CreateJournal do
  use Ecto.Migration

  def change do
    create table(:journals) do
      add :lang, :string
      add :body, :string
      add :title, :string

      timestamps()
    end

  end
end
