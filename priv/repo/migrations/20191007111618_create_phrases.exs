defmodule Phrasing.Repo.Migrations.CreatePhrases do
  use Ecto.Migration

  def change do
    create table(:phrases) do
      add :active, :boolean, default: true
      add :dialect, :text
      add :english, :text
      add :lang, :text
      add :literal, :text
      add :source, :text
      add :translit, :text

      timestamps()
    end
  end
end
