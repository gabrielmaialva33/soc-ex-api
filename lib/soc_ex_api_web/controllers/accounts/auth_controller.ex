defmodule SocExApiWeb.AuthController do
  use SocExApiWeb, :controller
  use Goal

  alias SocExApi.Guardian
  alias SocExApi.Accounts
  alias SocExApi.Accounts.User

  action_fallback SocExApiWeb.FallbackController

  # @auth_fields ~w(uid password)s

  def sign_in(conn, auth_params) do
    #    %{uid: uid, password: password} =
    #      auth_params
    #    e  |> Map.take(@auth_fields)
    #      |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
    #      |> Enum.into(%{})
    with {:ok, attrs} <- validate(:sign_in, auth_params) do
      IO.inspect(attrs, label: "attrs")

      case Accounts.confirm_password(attrs.uid, attrs.password) do
        {:ok, %User{} = user} ->
          {:ok, jwt, claims} = Guardian.encode_and_sign(user)
          render(conn, :sign_in, %{user: user, jwt: jwt, claims: claims})

        # cases
        # {:error, :user_not_found}
        # {:error, :invalid_password}

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
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(json: SocExApiWeb.ChangesetJSON)
        |> render(:error, changeset: changeset)
    end

    #    with {:ok, %User{} = user} <- Accounts.confirm_password(uid, password),
    #         {:ok, jwt, claims} <- Guardian.encode_and_sign(user) do
    #      render(conn, :sign_in, %{user: user, jwt: jwt, claims: claims})
    #    end
  end

  defparams :sign_in do
    required(:uid, :string)
    required(:password, :string, min_size: 8, max_size: 100)
  end
end
