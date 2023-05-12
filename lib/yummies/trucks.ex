defmodule Yummies.Trucks do
  @moduledoc """
  The Trucks context.
  """

  import Ecto.Query, warn: false
  require Logger

  alias Ecto.Multi
  alias Yummies.Repo
  alias Yummies.Trucks.Truck

  @doc """
  Returns the list of trucks.

  ## Examples

      iex> list_trucks()
      [%Truck{}, ...]

  """
  def list_trucks do
    Repo.all(Truck)
  end

  def list_trucks(options) do
    Enum.reduce(options, from(t in Truck), fn
      {:paginate, %{page: page, per_page: per_page}}, query ->
        from q in query,
          offset: ^((page - 1) * per_page),
          limit: ^per_page

      {:filter, %{foods: foods}}, query ->
        from q in query,
          where: ilike(q.foods, ^"%#{foods}%")
      end
    )
    |> Repo.all()
  end

  def count_trucks() do
    Repo.aggregate(from(p in Truck), :count, :id)
  end

  @doc """
  Gets a single truck.

  Raises `Ecto.NoResultsError` if the Truck does not exist.

  ## Examples

      iex> get_truck!(123)
      %Truck{}

      iex> get_truck!(456)
      ** (Ecto.NoResultsError)

  """
  def get_truck!(id), do: Repo.get!(Truck, id)

  @doc """
  Creates a truck.

  ## Examples

      iex> create_truck(%{field: value})
      {:ok, %Truck{}}

      iex> create_truck(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_truck(attrs \\ %{}) do
    %Truck{}
    |> Truck.changeset(attrs)
    |> Repo.insert()
  end

  def import_csv(filename) do
    File.stream!(filename, [], 1000)
    |> CSV.decode!()
    |> Stream.drop(1)
    |> Stream.map(fn [loc_id, applicant, facility, _cnn, loc_desc, address, _blocklot, _block, _lot, _permit, status, foods, _x, _y, lat, lng, _sched, _dayshours, _noisent, _approved, _received, _prior_permit, _exp_date, _location, _fpdistricts, _police_districts, _supervisor_districts, _zipcodes, _neighborhoods] ->
      type =
        case facility do
          "Truck" -> :truck
          "Push Cart" -> :cart
          _ -> ""
        end

      attrs =
        %{
          address: address,
          applicant: applicant,
          foods: foods,
          lid: loc_id,
          type: type,
          status: String.downcase(status)
        }

      Multi.new()
      |> Multi.insert(:truck, Truck.changeset(%Truck{}, attrs))
      |> Multi.insert(
        :location,
        fn %{truck: truck} ->
          {:ok, geom} = Geo.WKT.decode("SRID=4326;POINT(#{lat} #{lng})")
          loc_attrs = %{
            desc: loc_desc,
            geom: geom
          }
          Ecto.build_assoc(truck, :location, loc_attrs)
        end
      )
    end)
    |> Stream.map(fn
      %Ecto.Multi{operations: [location: _, truck: {:changeset, %Ecto.Changeset{valid?: true}, []}]} = multi ->
        Repo.transaction(multi)
      %Ecto.Multi{operations: [location: _, truck: {:changeset, %Ecto.Changeset{valid?: false}, []}]} ->
        Logger.warn("Failed to import food truck")
    end)
    |> Stream.run()
  end

  @doc """
  Updates a truck.

  ## Examples

      iex> update_truck(truck, %{field: new_value})
      {:ok, %Truck{}}

      iex> update_truck(truck, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_truck(%Truck{} = truck, attrs) do
    truck
    |> Truck.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a truck.

  ## Examples

      iex> delete_truck(truck)
      {:ok, %Truck{}}

      iex> delete_truck(truck)
      {:error, %Ecto.Changeset{}}

  """
  def delete_truck(%Truck{} = truck) do
    Repo.delete(truck)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking truck changes.

  ## Examples

      iex> change_truck(truck)
      %Ecto.Changeset{data: %Truck{}}

  """
  def change_truck(%Truck{} = truck, attrs \\ %{}) do
    Truck.changeset(truck, attrs)
  end
end
