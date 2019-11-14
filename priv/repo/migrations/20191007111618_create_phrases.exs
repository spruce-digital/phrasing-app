defmodule Phrasing.Repo.Migrations.CreatePhrases do
  use Ecto.Migration

  def change do
    create table(:phrases) do
      add :active, :boolean, default: true
      add :literal, :text
      add :source, :text
      add :source_lang, :text
      add :translation, :text
      add :translation_lang, :text
      add :translit, :text

      timestamps()
    end
  end
end
