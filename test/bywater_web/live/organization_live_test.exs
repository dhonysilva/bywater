defmodule BywaterWeb.OrganizationLiveTest do
  use BywaterWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bywater.AccountsFixtures

  @create_attrs %{active: true, name: "some name", slug: "some slug"}
  @update_attrs %{active: false, name: "some updated name", slug: "some updated slug"}
  @invalid_attrs %{active: false, name: nil, slug: nil}
  defp create_organization(_) do
    organization = organization_fixture()

    %{organization: organization}
  end

  describe "Index" do
    setup [:create_organization]

    test "lists all organizations", %{conn: conn, organization: organization} do
      {:ok, _index_live, html} = live(conn, ~p"/organizations")

      assert html =~ "Listing Organizations"
      assert html =~ organization.name
    end

    test "saves new organization", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/organizations")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Organization")
               |> render_click()
               |> follow_redirect(conn, ~p"/organizations/new")

      assert render(form_live) =~ "New Organization"

      assert form_live
             |> form("#organization-form", organization: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#organization-form", organization: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/organizations")

      html = render(index_live)
      assert html =~ "Organization created successfully"
      assert html =~ "some name"
    end

    test "updates organization in listing", %{conn: conn, organization: organization} do
      {:ok, index_live, _html} = live(conn, ~p"/organizations")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#organizations-#{organization.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/organizations/#{organization}/edit")

      assert render(form_live) =~ "Edit Organization"

      assert form_live
             |> form("#organization-form", organization: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#organization-form", organization: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/organizations")

      html = render(index_live)
      assert html =~ "Organization updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes organization in listing", %{conn: conn, organization: organization} do
      {:ok, index_live, _html} = live(conn, ~p"/organizations")

      assert index_live |> element("#organizations-#{organization.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#organizations-#{organization.id}")
    end
  end

  describe "Show" do
    setup [:create_organization]

    test "displays organization", %{conn: conn, organization: organization} do
      {:ok, _show_live, html} = live(conn, ~p"/organizations/#{organization}")

      assert html =~ "Show Organization"
      assert html =~ organization.name
    end

    test "updates organization and returns to show", %{conn: conn, organization: organization} do
      {:ok, show_live, _html} = live(conn, ~p"/organizations/#{organization}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/organizations/#{organization}/edit?return_to=show")

      assert render(form_live) =~ "Edit Organization"

      assert form_live
             |> form("#organization-form", organization: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#organization-form", organization: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/organizations/#{organization}")

      html = render(show_live)
      assert html =~ "Organization updated successfully"
      assert html =~ "some updated name"
    end
  end
end
