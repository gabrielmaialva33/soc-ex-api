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
        username: Faker.Internet.user_name(),
        first_name: Faker.Person.first_name(),
        last_name: Faker.Person.last_name(),
        email: Faker.Internet.email(),
        password: "Some@Password123",
        is_online: Faker.random_uniform() > Faker.random_uniform(),
        is_deleted: false
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
        name: Faker.Lorem.word(),
        slug: Faker.Lorem.word() |> String.upcase()
      })
      |> SocExApi.Accounts.create_role()

    role
  end
end
