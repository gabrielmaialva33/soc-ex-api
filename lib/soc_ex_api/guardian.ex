defmodule SocExApi.Guardian do
  @moduledoc """
  This module is responsible for encoding and decoding JWTs.
  """

  use Guardian, otp_app: :soc_ex_api

  alias SocExApi.Accounts

  @doc """
  Returns the subject for the token.
  """
  @spec subject_for_token(map, map) :: {:ok, String.t()} | {:error, any()}
  def subject_for_token(%{id: id}, _claims) do
    # You can use any value for the subject of your token but
    # it should be useful in retrieving the resource later, see
    # how it being used on `resource_from_claims/1` function.
    # A unique `id` is a good subject, a non-unique email address
    # is a poor subject.
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  @doc """
  Returns the resource for the token.
  """
  @spec resource_from_claims(map) :: {:ok, any()} | {:error, any()}
  def resource_from_claims(%{"sub" => id}) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In above `subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.
    resource = Accounts.get_user!(id)
    {:ok, resource}
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
