defmodule SocExApiWeb.UserJSON do
  alias SocExApi.Accounts.User
  alias SocExApiWeb.{PaginationJSOM, RoleJSON}

  @doc """
  Renders a paginated list of users.
  """
  def paginate(%{users: users, meta: meta}) do
    %{
      data: for(user <- users, do: data(user)),
      pagination: PaginationJSOM.render(meta)
    }
  end

  @doc """
  Renders a list of users.
  """
  def list(%{users: users}) do
    for(user <- users, do: data(user))
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  def render(%{user: user}) do
    data(user)
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      avatar_url: user.avatar_url,
      first_name: user.first_name,
      last_name: user.last_name,
      full_name: user.first_name <> " " <> user.last_name,
      email: user.email,
      username: user.username,
      is_online: user.is_online,
      roles: RoleJSON.list(%{roles: user.roles})
    }
  end
end
