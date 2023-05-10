defmodule Yummies.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      YummiesWeb.Telemetry,
      # Start the Ecto repository
      Yummies.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Yummies.PubSub},
      # Start Finch
      {Finch, name: Yummies.Finch},
      # Start the Endpoint (http/https)
      YummiesWeb.Endpoint
      # Start a worker by calling: Yummies.Worker.start_link(arg)
      # {Yummies.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Yummies.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    YummiesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
