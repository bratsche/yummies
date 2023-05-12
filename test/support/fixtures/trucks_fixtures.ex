defmodule Yummies.TrucksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Yummies.Trucks` context.
  """

  @doc """
  Generate a truck.
  """
  def truck_fixture(attrs \\ %{}) do
    {:ok, truck} =
      attrs
      |> Enum.into(%{
        address: "some address",
        applicant: "some applicant",
        foods: "some foods",
        lid: 42,
        status: :approved,
        type: :truck
      })
      |> Yummies.Trucks.create_truck()

    {:ok, geom} = Geo.WKT.decode("SRID=4326;POINT(37.755030726766726 -122.38453073422282)")
    Ecto.build_assoc(truck, :location, %{desc: "some place", geom: geom})
    |> Yummies.Repo.insert!()

    truck
  end
end
