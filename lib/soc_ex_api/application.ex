defmodule SocExApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SocExApiWeb.Telemetry,
      # Start the Ecto repository
      SocExApi.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: SocExApi.PubSub},
      # Start Finch
      {Finch, name: SocExApi.Finch},
      # Start the Endpoint (http/https)
      SocExApiWeb.Endpoint
      # Start a worker by calling: SocExApi.Worker.start_link(arg)
      # {SocExApi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SocExApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SocExApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
