defmodule Phrasing.Repo.Migrations.RemoveScripts do
  use Ecto.Migration

  def change do
    drop(table(:scripts))
  end
end
