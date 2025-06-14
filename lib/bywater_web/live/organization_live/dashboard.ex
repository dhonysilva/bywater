defmodule BywaterWeb.OrganizationLive.Dashboard do
  use BywaterWeb, :live_view

  alias Bywater.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <%!-- <pre><%= inspect assigns.current_scope, pretty: true  %></pre> --%>

      <.header>
        Dashboard for {@current_org.name}
        <:subtitle>Administrative Dashboard.</:subtitle>
        User role: {@current_membership.role}
        <:actions>
          <.button navigate={~p"/organizations"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button
            variant="primary"
            navigate={~p"/organizations/#{@organization}/edit?return_to=show"}
          >
            <.icon name="hero-pencil-square" /> Edit organization
          </.button>
        </:actions>
      </.header>

      <nav class="space-y-1">
        <.link
          navigate={~p"/orgs/#{@current_org.slug}/dashboard"}
          class="flex items-center px-3 py-2 text-sm font-medium rounded-md"
        >
          <.icon name="hero-home" class="mr-3 h-6 w-6" /> Dashboard
        </.link>

        <.link
          navigate={~p"/orgs/#{@current_org.slug}/projects"}
          class="flex items-center px-3 py-2 text-sm font-medium rounded-md"
        >
          <.icon name="hero-folder" class="mr-3 h-6 w-6" /> Projects
        </.link>

        <%= if @current_membership.role in ["admin", "manager"] do %>
          <.link
            navigate={~p"/orgs/#{@current_org.slug}/team"}
            class="flex items-center px-3 py-2 text-sm font-medium rounded-md"
          >
            <.icon name="hero-users" class="mr-3 h-6 w-6" /> Team Members
          </.link>
        <% end %>

        <%= if @current_membership.role == "admin" do %>
          <.link
            navigate={~p"/orgs/#{@current_org.slug}/settings"}
            class="flex items-center px-3 py-2 text-sm font-medium rounded-md"
          >
            <.icon name="hero-cog" class="mr-3 h-6 w-6" /> Settings
          </.link>
        <% end %>
      </nav>

      <.list>
        <:item title="Name">{@organization.name}</:item>
        <:item title="Slug">{@organization.slug}</:item>
        <:item title="Active">{@organization.active}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"org" => slug}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Dashboard")
     |> assign(current_user: socket.assigns.current_scope.user)
     |> assign(current_org: socket.assigns.current_scope.organization)
     |> assign(current_membership: socket.assigns.current_scope.membership)
     |> assign(:organization, Accounts.get_organization_by_slug!(slug))}
  end
end
