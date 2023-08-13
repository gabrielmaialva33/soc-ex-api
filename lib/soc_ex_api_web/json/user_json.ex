defmodule SocExApiWeb.UserJSON do
  alias SocExApi.Accounts.User
  alias SocExApiWeb.PaginationJSOM

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
  def index(%{users: users, meta: meta}) do
    %{data: for(user <- users, do: data(user)), pagination: PaginationJSOM.render(meta)}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      full_name: user.first_name <> " " <> user.last_name,
      email: user.email,
      username: user.username,
      is_online: user.is_online
    }
  end
end
