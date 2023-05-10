defmodule Yummies.TrucksTest do
  use Yummies.DataCase

  alias Yummies.Trucks

  describe "trucks" do
    alias Yummies.Trucks.Truck

    import Yummies.TrucksFixtures

    @invalid_attrs %{address: nil, applicant: nil, foods: nil, lid: nil, location_desc: nil, location_geo: nil, status: nil, type: nil}

    test "list_trucks/0 returns all trucks" do
      truck = truck_fixture()
      assert Trucks.list_trucks() == [truck]
    end

    test "get_truck!/1 returns the truck with given id" do
      truck = truck_fixture()
      assert Trucks.get_truck!(truck.id) == truck
    end

    test "create_truck/1 with valid data creates a truck" do
      valid_attrs = %{address: "some address", applicant: "some applicant", foods: "some foods", lid: 42, location_desc: "some location_desc", location_geo: "some location_geo", status: :approved, type: :truck}

      assert {:ok, %Truck{} = truck} = Trucks.create_truck(valid_attrs)
      assert truck.address == "some address"
      assert truck.applicant == "some applicant"
      assert truck.foods == "some foods"
      assert truck.lid == 42
      assert truck.location_desc == "some location_desc"
      assert truck.location_geo == "some location_geo"
      assert truck.status == :approved
      assert truck.type == :truck
    end

    test "create_truck/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trucks.create_truck(@invalid_attrs)
    end

    test "update_truck/2 with valid data updates the truck" do
      truck = truck_fixture()
      update_attrs = %{address: "some updated address", applicant: "some updated applicant", foods: "some updated foods", lid: 43, location_desc: "some updated location_desc", location_geo: "some updated location_geo", status: :expired, type: :cart}

      assert {:ok, %Truck{} = truck} = Trucks.update_truck(truck, update_attrs)
      assert truck.address == "some updated address"
      assert truck.applicant == "some updated applicant"
      assert truck.foods == "some updated foods"
      assert truck.lid == 43
      assert truck.location_desc == "some updated location_desc"
      assert truck.location_geo == "some updated location_geo"
      assert truck.status == :expired
      assert truck.type == :cart
    end

    test "update_truck/2 with invalid data returns error changeset" do
      truck = truck_fixture()
      assert {:error, %Ecto.Changeset{}} = Trucks.update_truck(truck, @invalid_attrs)
      assert truck == Trucks.get_truck!(truck.id)
    end

    test "delete_truck/1 deletes the truck" do
      truck = truck_fixture()
      assert {:ok, %Truck{}} = Trucks.delete_truck(truck)
      assert_raise Ecto.NoResultsError, fn -> Trucks.get_truck!(truck.id) end
    end

    test "change_truck/1 returns a truck changeset" do
      truck = truck_fixture()
      assert %Ecto.Changeset{} = Trucks.change_truck(truck)
    end
  end
end
