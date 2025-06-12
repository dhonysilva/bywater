defmodule BywaterWeb.OrganizationLive.Index do
  use BywaterWeb, :live_view

  alias Bywater.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <pre><%= inspect assigns.current_scope, pretty: true  %></pre>
      <.header>
        Listing Organizations
        <:actions>
          <.button variant="primary" navigate={~p"/organizations/new"}>
            <.icon name="hero-plus" /> New Organization
          </.button>
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
    organizations =
      if socket.assigns.current_scope && socket.assigns.current_scope.user do
        Accounts.list_user_organizations(socket.assigns.current_scope)
      else
        []
      end

    {:ok,
     socket
     |> assign(:page_title, "Listing Organizations")
     |> stream(:organizations, organizations)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    organization = Accounts.get_organization!(id)
    {:ok, _} = Accounts.delete_organization(organization)

    {:noreply, stream_delete(socket, :organizations, organization)}
  end
end
