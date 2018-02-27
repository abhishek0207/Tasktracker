defmodule TasktrackerWeb.ReporteeControllerTest do
  use TasktrackerWeb.ConnCase

  alias Tasktracker.Reports

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:reportee) do
    {:ok, reportee} = Reports.create_reportee(@create_attrs)
    reportee
  end

  describe "index" do
    test "lists all reportees", %{conn: conn} do
      conn = get conn, reportee_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Reportees"
    end
  end

  describe "new reportee" do
    test "renders form", %{conn: conn} do
      conn = get conn, reportee_path(conn, :new)
      assert html_response(conn, 200) =~ "New Reportee"
    end
  end

  describe "create reportee" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, reportee_path(conn, :create), reportee: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == reportee_path(conn, :show, id)

      conn = get conn, reportee_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Reportee"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, reportee_path(conn, :create), reportee: @invalid_attrs
      assert html_response(conn, 200) =~ "New Reportee"
    end
  end

  describe "edit reportee" do
    setup [:create_reportee]

    test "renders form for editing chosen reportee", %{conn: conn, reportee: reportee} do
      conn = get conn, reportee_path(conn, :edit, reportee)
      assert html_response(conn, 200) =~ "Edit Reportee"
    end
  end

  describe "update reportee" do
    setup [:create_reportee]

    test "redirects when data is valid", %{conn: conn, reportee: reportee} do
      conn = put conn, reportee_path(conn, :update, reportee), reportee: @update_attrs
      assert redirected_to(conn) == reportee_path(conn, :show, reportee)

      conn = get conn, reportee_path(conn, :show, reportee)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, reportee: reportee} do
      conn = put conn, reportee_path(conn, :update, reportee), reportee: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Reportee"
    end
  end

  describe "delete reportee" do
    setup [:create_reportee]

    test "deletes chosen reportee", %{conn: conn, reportee: reportee} do
      conn = delete conn, reportee_path(conn, :delete, reportee)
      assert redirected_to(conn) == reportee_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, reportee_path(conn, :show, reportee)
      end
    end
  end

  defp create_reportee(_) do
    reportee = fixture(:reportee)
    {:ok, reportee: reportee}
  end
end
