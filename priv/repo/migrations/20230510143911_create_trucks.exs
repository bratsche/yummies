defmodule Yummies.Repo.Migrations.CreateTrucks do
  use Ecto.Migration

  def change do
    create table(:trucks) do
      add :lid, :integer
      add :applicant, :string
      add :type, :string
      add :location_desc, :string
      add :address, :string
      add :status, :string
      add :foods, :string
      add :location_geo, :geometry

      timestamps()
    end
  end
end
