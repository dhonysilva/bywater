defmodule BywaterWeb.OrganizationLive.Index do
  use BywaterWeb, :live_view

  alias Bywater.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <%!-- <pre><%= inspect assigns.current_scope, pretty: true  %></pre> --%>
      <.header>
        Listing Organizations
        <:actions>
          <.organization_selector current_org={@current_org} user_organizations={@user_organizations} />
          <%!-- <.button variant="primary" navigate={~p"/organizations/new"}>
            <.icon name="hero-plus" /> New Organization
          </.button> --%>
        </:actions>
      </.header>

      <.table
        id="organizations"
        rows={@streams.organizations}
        row_click={fn {_id, organization} -> JS.navigate(~p"/organizations/#{organization}") end}
      >
        <:col :let={{_id, organization}} label="Name">{organization.name}</:col>
        <:col :let={{_id, organization}} label="Slug">{organization.slug}</:col>
        <:col :let={{_id, organization}} label="Active">{organization.active}</:col>
        <:action :let={{_id, organization}}>
          <div class="sr-only">
            <.link navigate={~p"/organizations/#{organization}"}>Show</.link>
          </div>
          <.link navigate={~p"/organizations/#{organization}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, organization}}>
          <.link
            phx-click={JS.push("delete", value: %{id: organization.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    user_organizations =
      if socket.assigns.current_scope && socket.assigns.current_scope.user do
        Accounts.list_user_organizations(socket.assigns.current_scope.user)
      else
        []
      end

    # Get the current organization (default to the first one if available)
    current_org =
      cond do
        socket.assigns.current_scope && socket.assigns.current_scope.organization ->
          socket.assigns.current_scope.organization

        Enum.count(user_organizations) > 0 ->
          List.first(user_organizations)

        true ->
          # Fallback empty organization
          %{id: nil, name: "Select Organization", slug: nil}
      end

    {:ok,
     socket
     |> assign(:page_title, "Listing Organizations")
     |> stream(:organizations, user_organizations)
     |> assign(:user_organizations, user_organizations)
     |> assign(:current_org, current_org)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    organization = Accounts.get_organization!(id)
    {:ok, _} = Accounts.delete_organization(organization)

    {:noreply, stream_delete(socket, :organizations, organization)}
  end

  # Organization selector component
  def organization_selector(assigns) do
    ~H"""
    <div class="mr-4">
      <.dropdown>
        <:trigger>
          <button type="button" class="flex items-center gap-2 p-2 border rounded hover:bg-base-200">
            <span>{@current_org.name}</span>
            <.icon name="hero-chevron-down" />
          </button>
        </:trigger>

        <:content>
          <%= for org <- @user_organizations do %>
            <li>
              <.link navigate={~p"/orgs/#{org.slug}/dashboard"}>
                {org.name}
              </.link>
            </li>
          <% end %>
          <li class="menu-title pt-2 mt-2 border-t border-base-300">
            <span>Actions</span>
          </li>
          <li>
            <.link navigate={~p"/organizations/new"}>
              Create New Organization
            </.link>
          </li>
        </:content>
      </.dropdown>
    </div>
    """
  end
end
