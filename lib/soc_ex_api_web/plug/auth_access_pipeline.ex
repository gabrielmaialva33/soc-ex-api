defmodule SocExApiWeb.Plug.AuthAccessPipeline do
  @moduledoc """
  Authentication access pipeline.
  """

  use Guardian.Plug.Pipeline,
    otp_app: :soc_ex_api,
    module: SocExApi.Guardian,
    error_handler: SocExApiWeb.Plug.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, scheme: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
