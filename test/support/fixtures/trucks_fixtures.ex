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
        location_desc: "some location_desc",
        location_geo: "some location_geo",
        status: :approved,
        type: :truck
      })
      |> Yummies.Trucks.create_truck()

    truck
  end
end
