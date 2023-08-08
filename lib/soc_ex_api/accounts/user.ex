defmodule SocExApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(username first_name last_name email password is_online is_deleted)a
  @optional_fields ~w(is_online is_deleted)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
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
  end
end
