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
          IO.inspect(user)
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

  def sign_up(conn, user_params) do
    with {:ok, attrs} <- validate(:sign_up, user_params) do
      with {:ok, %User{} = user} <- Accounts.create_user(attrs) do
        {:ok, jwt, claims} = Guardian.encode_and_sign(user)
        render(conn, :sign_up, %{user: user, jwt: jwt, claims: claims})
      end
    end
  end

  defparams :sign_in do
    required(:uid, :string)
    required(:password, :string)
  end

  defparams :sign_up do
    required(:first_name, :string, min_length?: 1, max_length?: 40)
    required(:last_name, :string, min_length?: 1, max_length?: 40)
    required(:username, :string, min_length?: 1, max_length?: 40)
    required(:email, :string, format?: ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/)
    required(:password, :string, format?: ~r/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$/)
    required(:password_confirmation, :string, equal?: :password)
  end
end
