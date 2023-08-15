defmodule SocExApi.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SocExApi.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        username: "some username",
        first_name: "some first_name",
        last_name: "some last_name",
        email: "some email",
        password_hash: "some password_hash",
        is_online: true,
        is_deleted: true
      })
      |> SocExApi.Accounts.create_user()

    user
  end

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        name: "some name",
        slug: "some slug"
      })
      |> SocExApi.Accounts.create_role()

    role
  end
end
