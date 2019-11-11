defmodule Phrasing.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :lang, :string
      add :title, :string

      timestamps()
    end

  end
end
