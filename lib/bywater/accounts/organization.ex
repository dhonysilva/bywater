defmodule Bywater.Accounts.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :slug}

  schema "organizations" do
    field :name, :string
    field :slug, :string
    field :active, :boolean, default: true

    many_to_many :users, Bywater.Accounts.User,
      join_through: Bywater.Accounts.OrganizationMembership

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :slug, :active])
    |> validate_required([:name, :slug])
    |> unique_constraint(:slug)
  end
end
