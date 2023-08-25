defmodule SocExApiWeb.AuthController do
  use SocExApiWeb, :controller
  use Goal

  alias SocExApi.Guardian
  alias SocExApi.Accounts
  alias SocExApi.Accounts.User

  action_fallback SocExApiWeb.FallbackController

  def sign_in(conn, auth_params) do
    with {:ok, attrs} <- validate(:sign_in, auth_params) do
      case Accounts.confirm_password(attrs.uid, attrs.password) do
        {:ok, %User{} = user} ->
          {:ok, jwt, claims} = Guardian.encode_and_sign(user)
          render(conn, :sign_in, %{user: user, jwt: jwt, claims: claims})

        {:error, :user_not_found} ->
          conn
          |> put_status(:not_found)
          |> put_view(json: SocExApiWeb.ErrorJSON)
          |> render(:"404")

        {:error, :invalid_password} ->
          conn
          |> put_status(:unprocessable_entity)
          |> put_view(json: SocExApiWeb.ErrorJSON)
          |> render(:"422")
      end
    end
  end

  defparams :sign_in do
    required(:uid, :string)
    required(:password, :string)
  end
end
