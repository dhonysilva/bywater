defmodule Bywater.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  # mix phx.gen.live Accounts Organization organizations name:string slug:string active:boolean

  def change do
    create table(:organizations) do
      add :name, :string
      add :slug, :string
      add :active, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
