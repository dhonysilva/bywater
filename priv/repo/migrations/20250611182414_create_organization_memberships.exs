defmodule Bywater.Repo.Migrations.CreateOrganizationMemberships do
  use Ecto.Migration

  # mix phx.gen.schema Accounts.OrganizationMembership organization_memberships user_id:references:users organization_id:references:organizations role:string

  def change do
    create table(:organization_memberships) do
      add :role, :string, null: false, default: "member"
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:organization_memberships, [:user_id, :organization_id])
    create index(:organization_memberships, [:user_id])
    create index(:organization_memberships, [:organization_id])
  end
end
