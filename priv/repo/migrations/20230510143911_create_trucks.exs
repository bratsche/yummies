defmodule Yummies.Repo.Migrations.CreateTrucks do
  use Ecto.Migration

  def change do
    create table(:trucks) do
      add :lid, :integer
      add :applicant, :string, null: false
      add :type, :string, null: false
      add :address, :string, null: false
      add :status, :string, null: false
      add :foods, :text, null: false

      timestamps()
    end
  end
end
