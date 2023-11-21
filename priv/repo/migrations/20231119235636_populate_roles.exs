defmodule SocExApi.Repo.Migrations.PopulateRoles do
  use Ecto.Migration

  alias SocExApi.Repo
  alias SocExApi.Accounts.Role

  def up do
    roles = [
      %Role{name: "Admin", slug: "admin"},
      %Role{name: "User", slug: "user"}
    ]

    Enum.each(roles, fn role ->
      Repo.insert(role)
    end)
  end

  def down do
    roles = [
      %{name: "Admin", slug: "admin"},
      %{name: "User", slug: "user"}
    ]

    Enum.each(roles, fn role ->
      Repo.delete_by(Role, role)
    end)
  end
end
