defmodule SocExApiWeb.Plug.AuthErrorHandler do
  @moduledoc """
  Handles authentication errors.
  """

  @behaviour Guardian.Plug.ErrorHandler

  import Plug.Conn

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, _reason}, _opts) do
    body = Jason.encode!(%{message: "Unauthorized access.", status: 401})
    send_resp(conn, 401, body)
  end
end
