defmodule SocExApi.UserFactory do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SocExApi` context.
  """

  alias SocExApi.Accounts.User
  alias SocExApi.Repo

  defmacro __using__(_) do
    quote do
      def user_factory do
        %User{
          username: Faker.Internet.user_name(),
          first_name: Faker.Person.first_name(),
          last_name: Faker.Person.last_name(),
          email: Faker.Internet.email(),
          password_hash: Argon2.hash_pwd_salt("Soc@551238"),
          is_online: Faker.random_uniform() > Faker.random_uniform(),
          is_deleted: Faker.random_uniform() > Faker.random_uniform()
        }
      end
    end
  end

  def user_factory do
    %User{
      username: Faker.Internet.user_name(),
      first_name: Faker.Person.first_name(),
      last_name: Faker.Person.last_name(),
      email: Faker.Internet.email(),
      password_hash: Argon2.hash_pwd_salt("Soc@551238"),
      is_online: Faker.random_uniform() > Faker.random_uniform(),
      is_deleted: Faker.random_uniform() > Faker.random_uniform()
    }
  end

  @spec create_user(any) :: any
  def create_user(attrs \\ %{}) do
    user = user_factory()

    user
    |> User.changeset(attrs)
    |> Repo.insert!()
  end

  def create_many_users(n, attrs \\ %{}) do
    Enum.map(1..n, fn _ ->
      create_user(attrs)
    end)
  end
end
