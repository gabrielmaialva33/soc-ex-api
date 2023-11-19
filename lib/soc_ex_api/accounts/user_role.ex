defmodule SocExApi.Accounts.UserRole do
  @moduledoc """
  UserRole schema and changeset.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias SocExApi.Accounts.{User, UserRole, Role}

  @required_fields ~w(user_id role_id)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @type t :: %UserRole{}
  schema "user_roles" do
    belongs_to :user, User, type: :binary_id
    belongs_to :role, Role, type: :binary_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `user_role` and `attrs`.
  """
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
