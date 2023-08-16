defmodule SocExApiWeb.AuthController do
  use SocExApiWeb, :controller
  use Goal

  alias SocExApi.Guardian
  alias SocExApi.Accounts
  alias SocExApi.Accounts.User

  action_fallback SocExApiWeb.FallbackController

  @auth_fields ~w(uid password)s

  def sign_in(conn, auth_params) do
    #    %{uid: uid, password: password} =
    #      auth_params
    #    e  |> Map.take(@auth_fields)
    #      |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
    #      |> Enum.into(%{})
    with {:ok,{uid: uid,password:password}} <- validate(:sign_in, auth_params) do
      IO.inspect({uid: uid,password:password})
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
