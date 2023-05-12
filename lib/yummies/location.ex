defmodule Yummies.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :desc, :string
    field :geom, Geo.PostGIS.Geometry

    belongs_to :truck, Yummies.Trucks.Truck

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:geom])
    |> validate_required([:geom])
  end
end
