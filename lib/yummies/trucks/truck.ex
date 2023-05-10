defmodule Yummies.Trucks.Truck do
  use Ecto.Schema
  import Ecto.Changeset

  schema "trucks" do
    field :address, :string
    field :applicant, :string
    field :foods, :string
    field :lid, :integer
    field :location_desc, :string
    field :location_geo, Geo.PostGIS.Geometry
    field :status, Ecto.Enum, values: [:approved, :expired, :requested, :suspend]
    field :type, Ecto.Enum, values: [:truck, :cart]

    timestamps()
  end

  @doc false
  def changeset(truck, attrs) do
    truck
    |> cast(attrs, [:lid, :applicant, :type, :location_desc, :address, :status, :foods, :location_geo])
    |> validate_required([:lid, :applicant, :type, :location_desc, :address, :status, :foods, :location_geo])
  end
end
