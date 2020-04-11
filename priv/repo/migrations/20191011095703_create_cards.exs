defmodule Phrasing.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add(:hint, :text)
      add(:lang, :text)
      add(:mnem, :text)
      add(:phrase_id, references(:phrases, on_delete: :nothing))
      add(:translation, :text)

      timestamps()
    end

    create(index(:cards, [:phrase_id]))
  end
end
