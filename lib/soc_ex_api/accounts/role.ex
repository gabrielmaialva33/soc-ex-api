defmodule SocExApi.Accounts.Role do
  @moduledoc """
  Role schema and changeset.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias SocExApi.Accounts.Role

  @required_fields ~w(name slug)a
  @optional_fields ~w()a
  @sortable_fields ~w(name slug)a

  # flop config schema
  @derive {
    Flop.Schema,
    filterable: @sortable_fields,
    sortable: @sortable_fields,
    default_order: %{
      order_by: @sortable_fields,
      order_directions: [:asc, :asc]
    }
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @type t :: %Role{}
  schema "roles" do
    field :name, :string
    field :slug, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `role` and `attrs`.
  """
  def changeset(role, attrs) do
    role
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_changeset
  end

  @spec validate_changeset(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_changeset(role) do
    role
    |> validate_length(:name, min: 1, max: 20)
    |> validate_length(:slug, min: 1, max: 20)
    |> validate_format(:name, ~r/^[a-z0-9_]+$/)
    |> validate_format(:slug, ~r/^[a-z0-9_]+$/)
    |> unique_constraint(:name)
  end
end
