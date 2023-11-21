defmodule SocExApi.RoleFactory do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SocExApi` context.
  """

  alias SocExApi.Accounts.Role
  alias SocExApi.Repo

  defmacro __using__(_) do
    quote do
      def role_factory do
        %Role{
          name: Faker.Lorem.word(),
          slug: Faker.Lorem.word() |> String.upcase()
        }
      end
    end
  end

  def role_factory do
    %Role{
      name: Faker.Lorem.word(),
      slug: Faker.Lorem.word() |> String.upcase()
    }
  end

  def create(attrs \\ %{}) do
    role = role_factory()

    role
    |> Role.changeset(attrs)
    |> Repo.insert!()
  end

  def create_many(n, attrs \\ %{}) do
    1..n
    |> Enum.map(fn _ -> create(attrs) end)
  end

  def make(attrs \\ %{}) do
    data = %{
      name: Faker.Lorem.word()
    }

    attrs =
      Enum.into(attrs, %{
        slug: data.name |> String.downcase()
      })

    data = Map.merge(data, attrs)
    data
  end

  def make_many(n, attrs \\ %{}) do
    1..n
    |> Enum.map(fn _ -> make(attrs) end)
  end
end
