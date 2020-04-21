defmodule Phrasing.Repo.Migrations.DropLibrary do
  use Ecto.Migration

  def change do
    drop(index(:chapters, [:book_id]))
    drop(table(:chapters))
    drop(table(:songs))
    drop(table(:books))
  end
end
