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

      iex> list_users(%Flop{page: 1, page_size: 10})
      {:ok, [%User{}, ...]}

      iex> list_users(%Flop{page: 2, page_size: 10})
      {:ok, [%User{}, ...]}
  """
  @spec list_users(map) :: {:ok, {[User.t()], Flop.Meta.t()}} | {:error, Flop.Meta.t()}
  def list_users(flop \\ %Flop{}) do
    query =
      from u in User,
        where: u.is_deleted != true,
        select: u,
        preload: [:roles]

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
        select: u,
        preload: [:roles]

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

  @doc """
  Confirms a user's password.
  """
  @spec confirm_password(String.t(), String.t()) :: {:ok, User.t()} | {:error, atom()}
  def confirm_password(uid, password) do
    query =
      from u in User,
        where: u.is_deleted != true,
        where: u.email == ^uid or u.username == ^uid,
        limit: 1,
        preload: [:roles],
        select: u

    case Repo.one(query) do
      nil ->
        {:error, :user_not_found}

      %User{} = user ->
        case Argon2.verify_pass(password, user.password_hash) do
          true ->
            {:ok, user}

          false ->
            {:error, :invalid_password}
        end
    end
  end

  alias SocExApi.Accounts.Role

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles(%Flop{page: 1, page_size: 10})
      {:ok, [%Role{}, ...]}

      iex> list_roles(%Flop{page: 2, page_size: 10})
      {:ok, [%Role{}, ...]}
  """
  @spec list_roles(map) :: {:ok, [Role.t()]} | {:error, Flop.Meta.t()}
  def list_roles(flop \\ %Flop{}) do
    query =
      from r in Role, select: r

    Flop.validate_and_run(query, flop, for: Role)
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{data: %Role{}}

  """
  def change_role(%Role{} = role, attrs \\ %{}) do
    Role.changeset(role, attrs)
  end
end
