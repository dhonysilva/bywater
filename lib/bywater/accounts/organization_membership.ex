defmodule Bywater.Accounts.OrganizationMembership do
  use Ecto.Schema
  import Ecto.Changeset

  @roles ~w(admin manager member)a

  schema "organization_memberships" do
    field :role, :string, default: "member"

    belongs_to :user, Bywater.Accounts.User
    belongs_to :organization, Bywater.Accounts.Organization

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization_membership, attrs) do
    organization_membership
    |> cast(attrs, [:role, :user_id, :organization_id])
    |> validate_required([:role, :user_id, :organization_id])
    |> validate_inclusion(:role, Enum.map(@roles, &Atom.to_string/1))
    |> unique_constraint([:user_id, :organization_id])
  end
end
