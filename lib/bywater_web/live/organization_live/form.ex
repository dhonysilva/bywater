defmodule BywaterWeb.OrganizationLive.Form do
  use BywaterWeb, :live_view

  alias Bywater.Accounts
  alias Bywater.Accounts.Organization

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage organization records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="organization-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:slug]} type="text" label="Slug" />
        <.input field={@form[:active]} type="checkbox" label="Active" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Organization</.button>
          <.button navigate={return_path(@return_to, @organization)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    organization = Accounts.get_organization!(id)

    socket
    |> assign(:page_title, "Edit Organization")
    |> assign(:organization, organization)
    |> assign(:form, to_form(Accounts.change_organization(organization)))
  end

  defp apply_action(socket, :new, _params) do
    organization = %Organization{}

    socket
    |> assign(:page_title, "New Organization")
    |> assign(:organization, organization)
    |> assign(:form, to_form(Accounts.change_organization(organization)))
  end

  @impl true
  def handle_event("validate", %{"organization" => organization_params}, socket) do
    changeset = Accounts.change_organization(socket.assigns.organization, organization_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"organization" => organization_params}, socket) do
    save_organization(socket, socket.assigns.live_action, organization_params)
  end

  defp save_organization(socket, :edit, organization_params) do
    case Accounts.update_organization(socket.assigns.organization, organization_params) do
      {:ok, organization} ->
        {:noreply,
         socket
         |> put_flash(:info, "Organization updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, organization))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_organization(socket, :new, organization_params) do
    case Accounts.create_organization(organization_params) do
      {:ok, organization} ->
        # Create membership for the current user
        {:ok, _membership} =
          Accounts.create_membership(%{
            user_id: socket.assigns.current_scope.user.id,
            organization_id: organization.id,
            role: "admin"
          })

        {:noreply,
         socket
         |> put_flash(:info, "Organization created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, organization))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _organization), do: ~p"/organizations"
  defp return_path("show", organization), do: ~p"/organizations/#{organization}"
end
