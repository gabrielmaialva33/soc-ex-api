defmodule SocExApi.UserFactory do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SocExApi` context.
  """

  alias SocExApi.Accounts.{User, Role, UserRole}
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
      is_online: Faker.random_uniform() > Faker.random_uniform(),
      is_deleted: Faker.random_uniform() > Faker.random_uniform()
    }
  end

  @spec create(any) :: any
  def create(attrs \\ %{}, opts \\ []) do
    user = user_factory()

    attrs = Map.put(attrs, :password, "Soc@551238")

    user
    |> User.changeset(attrs)
    |> Repo.insert!()
    |> set_roles(opts)
    |> Repo.preload([:roles])
    |> Map.put(:password, nil)
  end

  def create_many(n, attrs \\ %{}) do
    1..n
    |> Enum.map(fn _ -> create(attrs) end)
  end

  def make(attrs \\ %{}) do
    data = %{
      username: Faker.Internet.user_name(),
      first_name: Faker.Person.first_name(),
      last_name: Faker.Person.last_name(),
      email: Faker.Internet.email(),
      is_online: Faker.random_uniform() > Faker.random_uniform(),
      is_deleted: Faker.random_uniform() > Faker.random_uniform()
    }

    data = Map.put(data, :password, "Soc@551238")
    data = Map.merge(data, attrs)
    data
  end

  def make_many(n, attrs \\ %{}) do
    1..n
    |> Enum.map(fn _ -> make(attrs) end)
  end

  defp set_roles(user, opts \\ []) do
    if opts[:roles] do
      roles = opts[:roles]

      Enum.each(roles, fn role ->
        role = Repo.get_by(Role, slug: role)
        %UserRole{user_id: user.id, role_id: role.id} |> Repo.insert!()
      end)

      user
    else
      user_role = Repo.get_by(Role, slug: "user")
      %UserRole{user_id: user.id, role_id: user_role.id} |> Repo.insert!()
      user
    end
  end
end
