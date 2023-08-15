defmodule SocExApi.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()"), null: false
      add :name, :string, size: 20, null: false, unique: true
      add :slug, :string, size: 20, null: false

      timestamps()
    end

    create unique_index(:roles, [:name])
  end
end
