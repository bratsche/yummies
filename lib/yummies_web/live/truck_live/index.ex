defmodule YummiesWeb.TruckLive.Index do
  use YummiesWeb, :live_view

  alias Yummies.Trucks
  alias Yummies.Trucks.Truck

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :trucks, Trucks.list_trucks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Truck")
    |> assign(:truck, Trucks.get_truck!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Truck")
    |> assign(:truck, %Truck{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Trucks")
    |> assign(:truck, nil)
  end

  @impl true
  def handle_info({YummiesWeb.TruckLive.FormComponent, {:saved, truck}}, socket) do
    {:noreply, stream_insert(socket, :trucks, truck)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    truck = Trucks.get_truck!(id)
    {:ok, _} = Trucks.delete_truck(truck)

    {:noreply, stream_delete(socket, :trucks, truck)}
  end
end
