defmodule SocExApiWeb.AuthController do
  use SocExApiWeb, :controller
  use Goal

  alias SocExApi.Guardian
  alias SocExApi.Accounts
  alias SocExApi.Accounts.User

  action_fallback SocExApiWeb.FallbackController

  @auth_fields ~w(uid password)s

  def sign_in(conn, auth_params) do
    with {:ok, %User{} = user} <- Accounts.confirm_password(auth_params),
         {:ok, jwt, claims} <- Guardian.encode_and_sign(user) do
      render(conn, :sign_in, %{user: user, jwt: jwt, claims: claims})
    end
  end

  defparams :sign_in do
    required(:uid, :string)
    required(:password, :string, min_size: 8, max_size: 100)
  end
end
