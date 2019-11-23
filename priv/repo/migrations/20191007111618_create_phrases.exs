defmodule Phrasing.Repo.Migrations.CreatePhrases do
  use Ecto.Migration

  def change do
    create table(:phrases) do
      add :active, :boolean, default: true
      add :lang, :text
      add :translations, :map

      timestamps()
    end
  end
end
