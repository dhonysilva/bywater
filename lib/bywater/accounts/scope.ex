defmodule Bywater.Accounts.Scope do
  @moduledoc """
  Defines the scope of the caller to be used throughout the app.

  The `Bywater.Accounts.Scope` allows public interfaces to receive
  information about the caller, such as if the call is initiated from an
  end-user, and if so, which user. Additionally, such a scope can carry fields
  such as "super user" or other privileges for use as authorization, or to
  ensure specific code paths can only be access for a given scope.

  It is useful for logging as well as for scoping pubsub subscriptions and
  broadcasts when a caller subscribes to an interface or performs a particular
  action.

  Feel free to extend the fields on this struct to fit the needs of
  growing application requirements.
  """

  alias Bywater.Accounts.User
  alias Bywater.Accounts.Organization
  alias Bywater.Accounts.OrganizationMembership

  defstruct user: nil, organization: nil, membership: nil

  @doc """
  Creates a scope for the given user.

  Returns nil if no user is given.
  """
  def for_user(%User{} = user) do
    %__MODULE__{user: user}
  end

  def for_user(nil), do: nil

  def put_user(%__MODULE__{} = scope, %User{} = user) do
    %{scope | user: user}
  end

  def put_organization(%__MODULE__{user: user} = scope, %Organization{} = org) do
    membership = get_membership(user, org)
    %{scope | organization: org, membership: membership}
  end

  def put_membership(%__MODULE__{} = scope, %OrganizationMembership{} = membership) do
    %{scope | membership: membership}
  end

  defp get_membership(%User{id: user_id}, %Organization{id: org_id}) do
    Bywater.Repo.get_by(OrganizationMembership, user_id: user_id, organization_id: org_id)
  end
end
