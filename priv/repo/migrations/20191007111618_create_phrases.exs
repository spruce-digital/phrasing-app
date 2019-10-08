defmodule Phrasing.Repo.Migrations.CreatePhrases do
  use Ecto.Migration

  def change do
    create table(:phrases) do
      add :source, :text
      add :english, :text
      add :lang, :text

      timestamps()
    end

  end
end
