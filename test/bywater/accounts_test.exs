defmodule Bywater.AccountsTest do
  use Bywater.DataCase

  alias Bywater.Accounts

  describe "organizations" do
    alias Bywater.Accounts.Organization

    import Bywater.AccountsFixtures

    @invalid_attrs %{active: nil, name: nil, slug: nil}

    test "list_organizations/0 returns all organizations" do
      organization = organization_fixture()
      assert Accounts.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert Accounts.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      valid_attrs = %{active: true, name: "some name", slug: "some slug"}

      assert {:ok, %Organization{} = organization} = Accounts.create_organization(valid_attrs)
      assert organization.active == true
      assert organization.name == "some name"
      assert organization.slug == "some slug"
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()
      update_attrs = %{active: false, name: "some updated name", slug: "some updated slug"}

      assert {:ok, %Organization{} = organization} = Accounts.update_organization(organization, update_attrs)
      assert organization.active == false
      assert organization.name == "some updated name"
      assert organization.slug == "some updated slug"
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_organization(organization, @invalid_attrs)
      assert organization == Accounts.get_organization!(organization.id)
    end

    test "delete_organization/1 deletes the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{}} = Accounts.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = Accounts.change_organization(organization)
    end
  end
end
