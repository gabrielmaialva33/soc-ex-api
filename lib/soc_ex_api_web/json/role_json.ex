defmodule SocExApiWeb.RoleJSON do
  alias SocExApi.Accounts.Role
  alias SocExApiWeb.PaginationJSOM

  @doc """
  Renders a paginated list of roles.
  """
  def paginate(%{roles: roles, meta: meta}) do
    %{
      data: for(role <- roles, do: data(role)),
      pagination: PaginationJSOM.render(meta)
    }
  end

  @doc """
  Renders a list of roles.
  """
  def list(%{roles: roles}) do
    for(role <- roles, do: data(role))
  end

  @doc """
  Renders a single role.
  """
  def show(%{role: role}) do
    %{data: data(role)}
  end

  def render(%{role: role}) do
    data(role)
  end

  defp data(%Role{} = role) do
    %{
      id: role.id,
      name: role.name,
      slug: role.slug
    }
  end
end
