defmodule Bywater.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bywater.Accounts` context.
  """

  @doc """
  Generate a organization.
  """
  def organization_fixture(attrs \\ %{}) do
    {:ok, organization} =
      attrs
      |> Enum.into(%{
        active: true,
        name: "some name",
        slug: "some slug"
      })
      |> Bywater.Accounts.create_organization()

    organization
  end
end
