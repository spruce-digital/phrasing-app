defmodule Phrasing.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :body, :string
      add :lang, :string
      add :title, :string
      add :url, :string

      timestamps()
    end

  end
end
