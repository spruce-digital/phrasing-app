defmodule Phrasing.Repo.Migrations.AddActiveToCard do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add(:active, :boolean, default: true)
    end
  end
end
