defmodule SocExApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias SocExApi.Repo

  alias SocExApi.Accounts.User

  @doc """
  Returns a paginated list of users.

  ### Examples

      iex> paginate_users(%Flop{page: 1, page_size: 10})
      {:ok, [%User{}, ...]}

      iex> paginate_users(%Flop{page: 2, page_size: 10})
      {:ok, [%User{}, ...]}
  """
  @spec paginate_users(map) :: {:ok, {[User.t()], Flop.Meta.t()}} | {:error, Flop.Meta.t()}
  def paginate_users(flop \\ %Flop{}) do
    query =
      from u in User,
        where: u.is_deleted != true,
        select: u

    Flop.validate_and_run(query, flop, for: User)
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  @spec list_users(map) :: {:ok, [User.t()]} | {:error, Flop.Meta.t()}
  def list_users(flop \\ %Flop{}) do
    query =
      from u in User,
        where: u.is_deleted != true,
        select: u

    # load flop without meta
    Flop.validate_and_run(query, flop, for: User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    query =
      from u in User,
        where: u.id == ^id and u.is_deleted != true,
        select: u

    Repo.one!(query)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
