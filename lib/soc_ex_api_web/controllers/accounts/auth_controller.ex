defmodule SocExApiWeb.AuthController do
  use SocExApiWeb, :controller

  alias SocExApi.Guardian
  alias SocExApi.Accounts
  alias SocExApi.Accounts.User

  action_fallback SocExApiWeb.FallbackController

  @auth_fields ~w(uid password)s

  def sign_in(conn, auth_params) do
    %{uid: uid, password: password} =
      auth_params
      |> Map.take(@auth_fields)
      |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
      |> Enum.into(%{})

    with {:ok, %User{} = user} <- Accounts.confirm_password(uid, password),
         {:ok, jwt, claims} <- Guardian.encode_and_sign(user) do
      render(conn, :sign_in, %{user: user, jwt: jwt, claims: claims})
    end
  end
end
