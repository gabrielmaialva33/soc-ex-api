defmodule SocExApi.Accounts.User do
  @moduledoc """
  User schema and changeset.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias SocExApi.Accounts.User

  @required_fields ~w(username first_name last_name email password is_online is_deleted)a
  @optional_fields ~w(is_online is_deleted)a
  @sortable_fields ~w(first_name last_name username email)a

  # flop config schema
  @derive {
    Flop.Schema,
    filterable: @sortable_fields,
    sortable: @sortable_fields,
    default_order: %{
      order_by: @sortable_fields,
      order_directions: [:asc, :asc, :asc, :asc]
    }
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @type t :: %User{}
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :is_online, :boolean, default: false
    field :is_deleted, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_changeset
  end

  @spec validate_changeset(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  @doc false
  defp validate_changeset(user) do
    user
    |> validate_length(:first_name, min: 1, max: 40)
    |> validate_length(:last_name, min: 1, max: 40)
    |> validate_length(:username, min: 1, max: 40)
    |> validate_length(:email, min: 1, max: 100)
    |> validate_length(:password, min: 1, max: 50)
    |> validate_format(:first_name, ~r/^[a-zA-Z0-9_.+-]+$/)
    |> validate_format(:last_name, ~r/^[a-zA-Z0-9_.+-]+$/)
    |> validate_format(:email, ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/)
    |> validate_format(:username, ~r/^[a-zA-Z0-9_.+-]+$/)
    |> validate_format(:password, ~r/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$/)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> password_hash
  end

  @spec password_hash(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  @doc false
  defp password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password, salt_len: 32))

      _ ->
        changeset
    end
  end
end
