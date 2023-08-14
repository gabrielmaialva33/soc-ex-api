defmodule SocExApiWeb.Router do
  use SocExApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SocExApiWeb do
    pipe_through :api

    get "/users/paginate", UserController, :paginate
    resources "/users", UserController, except: [:new, :edit]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:soc_ex_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard",
        metrics: SocExApiWeb.Telemetry,
        metrics_history: {MyApp.MetricsStorage, :metrics_history, []},
        ecto_repos: [SocExApiWeb.Repo],
        ecto_psql_extras_options: [long_running_queries: [threshold: "200 milliseconds"]]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
