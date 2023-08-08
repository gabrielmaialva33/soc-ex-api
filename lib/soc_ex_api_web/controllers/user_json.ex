defmodule SocExApiWeb.UserJSON do
  alias SocExApi.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
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
