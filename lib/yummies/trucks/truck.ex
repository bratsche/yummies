defmodule Yummies.Trucks.Truck do
  use Ecto.Schema
  import Ecto.Changeset

  schema "trucks" do
    field :address, :string
    field :applicant, :string
    field :foods, :string
    field :lid, :integer
    field :status, Ecto.Enum, values: [:approved, :expired, :requested, :suspend]
    field :type, Ecto.Enum, values: [:truck, :cart]

    has_one :location, Yummies.Location

    timestamps()
  end

  @doc false
  def changeset(truck, attrs) do
    truck
    |> cast(attrs, [:lid, :applicant, :type, :address, :status, :foods])
    |> validate_required([:lid, :applicant, :type, :address, :status, :foods])
  end
end
