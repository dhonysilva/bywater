defmodule BywaterWeb.OrganizationLive.Show do
  use BywaterWeb, :live_view

  alias Bywater.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <pre><%= inspect assigns.current_scope, pretty: true  %></pre>
      <.header>
        Organization {@organization.id}
        <:subtitle>This is a organization record from your database.</:subtitle>
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
     |> assign(:page_title, "Show Organization")
     |> assign(:organization, Accounts.get_organization_by_slug!(slug))}
  end
end
