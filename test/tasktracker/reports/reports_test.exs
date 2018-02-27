defmodule Tasktracker.ReportsTest do
  use Tasktracker.DataCase

  alias Tasktracker.Reports

  describe "reportees" do
    alias Tasktracker.Reports.Reportee

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def reportee_fixture(attrs \\ %{}) do
      {:ok, reportee} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reports.create_reportee()

      reportee
    end

    test "list_reportees/0 returns all reportees" do
      reportee = reportee_fixture()
      assert Reports.list_reportees() == [reportee]
    end

    test "get_reportee!/1 returns the reportee with given id" do
      reportee = reportee_fixture()
      assert Reports.get_reportee!(reportee.id) == reportee
    end

    test "create_reportee/1 with valid data creates a reportee" do
      assert {:ok, %Reportee{} = reportee} = Reports.create_reportee(@valid_attrs)
    end

    test "create_reportee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reports.create_reportee(@invalid_attrs)
    end

    test "update_reportee/2 with valid data updates the reportee" do
      reportee = reportee_fixture()
      assert {:ok, reportee} = Reports.update_reportee(reportee, @update_attrs)
      assert %Reportee{} = reportee
    end

    test "update_reportee/2 with invalid data returns error changeset" do
      reportee = reportee_fixture()
      assert {:error, %Ecto.Changeset{}} = Reports.update_reportee(reportee, @invalid_attrs)
      assert reportee == Reports.get_reportee!(reportee.id)
    end

    test "delete_reportee/1 deletes the reportee" do
      reportee = reportee_fixture()
      assert {:ok, %Reportee{}} = Reports.delete_reportee(reportee)
      assert_raise Ecto.NoResultsError, fn -> Reports.get_reportee!(reportee.id) end
    end

    test "change_reportee/1 returns a reportee changeset" do
      reportee = reportee_fixture()
      assert %Ecto.Changeset{} = Reports.change_reportee(reportee)
    end
  end
end
