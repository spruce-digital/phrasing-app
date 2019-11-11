defmodule Phrasing.Repo.Migrations.CreateChapters do
  use Ecto.Migration

  def change do
    create table(:chapters) do
      add :body, :map
      add :book_id, references(:books, on_delete: :delete_all)

      timestamps()
    end

    create index(:chapters, [:book_id])
  end
end
