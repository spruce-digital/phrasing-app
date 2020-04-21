defmodule Phrasing.Repo.Migrations.CreateDialogues do
  use Ecto.Migration

  def change do
    create table(:dialogues) do
      add(:title, :string)
      add(:author_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:dialogues, [:author_id]))
  end
end
