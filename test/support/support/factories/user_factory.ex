defmodule SocExApi.UserFactory do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SocExApi` context.
  """

  alias SocExApi.Accounts.User

  defmacro __using__(_) do
    quote do
      def user_factory do
        %User{
          username: Faker.Internet.user_name(),
          first_name: Faker.Name.first_name(),
          last_name: Faker.Name.last_name(),
          email: Faker.Internet.email(),
          password_hash: Argon2.hash_pwd_salt(Faker.Internet.password()),
          is_online: Faker.Boolean.boolean(),
          is_deleted: Faker.Boolean.boolean()
        }
      end
    end
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> Ecto.build_assoc(:user, Map.merge(user_factory(), attrs))
    |> Repo.insert!()
  end

  def create_many_users(n, attrs \\ %{}) do
    Enum.map(1..n, fn _ ->
      create_user(attrs)
    end)
  end
end
