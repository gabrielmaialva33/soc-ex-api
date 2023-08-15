defmodule SocExApi.Repo.Migrations.CreateUsersRoles do
  use Ecto.Migration

  def change do
    create table(:users_roles, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()"), null: false
      add :user_id, references(:users, type: :binary_id), null: false
      add :role_id, references(:roles, type: :binary_id), null: false

      timestamps()
    end

    create unique_index(:users_roles, [:user_id, :role_id])
  end
end
