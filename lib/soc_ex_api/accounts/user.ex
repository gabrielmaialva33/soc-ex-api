defmodule SocExApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :username, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password_hash, :string
    field :is_online, :boolean, default: false
    field :is_deleted, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :first_name,
      :last_name,
      :email,
      :username,
      :password_hash,
      :is_online,
      :is_deleted
    ])
    |> validate_required([
      :first_name,
      :last_name,
      :email,
      :username,
      :password_hash,
      :is_online,
      :is_deleted
    ])
  end
end
