defmodule YummiesWeb.TruckLiveTest do
  use YummiesWeb.ConnCase

  import Phoenix.LiveViewTest
  import Yummies.TrucksFixtures

  defp create_truck(_) do
    truck = truck_fixture()
    %{truck: truck}
  end

  describe "Index" do
    setup [:create_truck]

    test "lists all trucks", %{conn: conn, truck: truck} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "Listing Trucks"
      assert html =~ truck.address
    end
  end
end
