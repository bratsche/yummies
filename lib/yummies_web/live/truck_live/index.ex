defmodule YummiesWeb.TruckLive.Index do
  use YummiesWeb, :live_view

  alias Yummies.{Repo, Trucks}

  @default_per_page 10

  @impl true
  def mount(_params, _session, socket) do
    options = %{page: 1, per_page: @default_per_page}
    n_trucks = Trucks.count_trucks()
    n_pages = Float.ceil(n_trucks / @default_per_page)
    trucks = Trucks.list_trucks(paginate: options) |> Repo.preload(:location)

    api_key = System.get_env("GOOGLE_MAPS_API_KEY", "")

    socket =
      socket
      |> assign(:options, options)
      |> assign(:n_trucks, n_trucks)
      |> assign(:n_pages, n_pages)
      |> assign(:trucks, trucks)
      |> assign(:filter, "")
      |> assign(:api_key, api_key)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "10")
    options = %{page: page, per_page: per_page}
    trucks = Trucks.list_trucks([filter: %{foods: socket.assigns.filter}, paginate: options]) |> Repo.preload(:location)

    socket =
      socket
      |> push_event("clear_trucks", %{})
      |> assign(options: options)
      |> assign(:trucks, trucks)

    socket =
      Enum.reduce(trucks, socket, fn truck, sock ->
        {lat, lng} = truck.location.geom.coordinates
        push_event(sock, "add_truck", %{truck: %{latitude: lat, longitude: lng}})
      end)

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("filter_changed", %{"filter" => filter}, socket) do
    trucks = Trucks.list_trucks([paginate: socket.assigns.options, filter: %{foods: filter}]) |> Repo.preload(:location)

    socket =
      socket
      |> assign(trucks: trucks)
      |> assign(filter: filter)

    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Trucks")
    |> assign(:truck, nil)
  end

  defp pagination_nav(assigns) do
    ~H"""
    <div class="bg-cool-gray-300 pb-3">
      <nav class="border-t border-gray-200 px-4 flex items-center justify-between sm:px-0">
        <div class="-mt-px w-0 flex-1 flex">
          <%= if @page > 1 do %>
            <.page_link page={@page - 1} class="px-4 border-t-2 border-transparent pt-4 pr-1 inline-flex items-center text-sm font-medium text-gray-700 hover:text-gray-900 hover:border-gray-300">
              Previous
            </.page_link>
          <% end %>
        </div>
        <div class="hidden md:-mt-px md:flex">
          <%= for i <- (@page - 2)..(@page + 2), i > 0 do %>
            <%= if i <= @n_pages do %>
              <.page_link page={i} class="px-4 border-t-2 border-transparent pt-4 pr-1 inline-flex items-center text-sm font-medium text-gray-700 hover:text-gray-900 hover:border-gray-300">
                <%= i %>
              </.page_link>
            <% end %>
          <% end %>
        </div>
        <div class="-mt-px w-0 flex-1 flex justify-end">
          <%= if @page < @n_pages do %>
            <.page_link page={@page + 1} class="px-4 border-t-2 border-transparent pt-4 pr-1 inline-flex items-center text-sm font-medium text-gray-700 hover:text-gray-900 hover:border-gray-300">
              Next
            </.page_link>
          <% end %>
        </div>
      </nav>
    </div>
    """
  end

  defp page_link(assigns) do
    ~H"""
    <.link patch={~p"/trucks?page=#{@page}"}>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end
end
