defmodule Yummies.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :desc, :string, null: false
      add :geom, :geometry, null: false
      add :truck_id, references(:trucks, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:locations, [:truck_id])
  end
end
