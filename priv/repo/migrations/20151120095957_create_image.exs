defmodule Gyazo.Repo.Migrations.CreateImage do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :gyazo_id, :string
      add :hash, :string

      timestamps
    end

    create index(:images, [:hash], unique: true)
  end
end
