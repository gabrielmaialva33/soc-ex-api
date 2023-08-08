defmodule SocExApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()"), null: false
      add :first_name, :string, size: 40, null: false
      add :last_name, :string, size: 40, null: false
      add :email, :string, size: 100, null: false
      add :username, :string, size: 40, null: false
      add :password_hash, :string, size: 118, null: false
      add :is_online, :boolean, default: false, null: false
      add :is_deleted, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])
  end
end
