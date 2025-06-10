defmodule BywaterWeb.ErrorJSONTest do
  use BywaterWeb.ConnCase, async: true

  test "renders 404" do
    assert BywaterWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert BywaterWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
