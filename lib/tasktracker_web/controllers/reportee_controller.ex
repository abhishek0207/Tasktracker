defmodule TasktrackerWeb.ReporteeController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Reports
  alias Tasktracker.Reports.Reportee

  def index(conn, _params) do
    reportees = Reports.list_reportees()
    render(conn, "index.html", reportees: reportees)
  end

  def get_reportees(conn, _params) do
    current_user = conn.assigns[:current_user]
    if(current_user) do
    ismanager = Tasktracker.Accounts.is_manager(current_user.id)
      if(ismanager) do
        reportees = Reports.my_reportees(current_user.id)
          if(reportees) do
              render(conn, "resources.html", reportees: reportees)
            else
                conn
                |> put_flash(:error, "You do not have any reportees assigned to you, kindly add some resources")
                |> redirect(to: page_path(conn, :index))
            end
    else
      conn
      |> put_flash(:error, "You do not have access to this page")
      |> redirect(to: page_path(conn, :index))
    end
  else
    conn
    |> put_flash(:error, "Unauthorized Access")
    |> redirect(to: page_path(conn, :index))
  end
  end

  def new(conn, _params) do
    current_user = conn.assigns[:current_user]
    manager_check = Tasktracker.Accounts.is_manager(current_user.id)
    if(manager_check == true) do
    changeset = Reports.change_reportee(%Reportee{})
    render(conn, "new.html", changeset: changeset)
  else
    conn
    |> put_flash(:error, "only managers can add reportees")
    |> redirect(to: page_path(conn, :index))
  end
  end

  def create(conn, %{"reportee" => reportee_params}) do
    reportee_params_add = %{"manager_id" => reportee_params["manager_id"], "user_id" => reportee_params["repotee_id"]}
    addReportees(conn, reportee_params_add)
  end

  def show(conn, %{"id" => id}) do
    reportee = Reports.get_reportee(id)
    render(conn, "show.html", reportee: reportee)
  end

  def edit(conn, %{"id" => id}) do
    reportee = Reports.get_reportee!(id)
    changeset = Reports.change_reportee(reportee)
    render(conn, "edit.html", reportee: reportee, changeset: changeset)
  end

  def update(conn, %{"id" => id, "reportee" => reportee_params}) do
    reportee = Reports.get_reportee!(id)

    case Reports.update_reportee(reportee, reportee_params) do
      {:ok, reportee} ->
        conn
        |> put_flash(:info, "Reportee updated successfully.")
        |> redirect(to: reportee_path(conn, :show, reportee))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", reportee: reportee, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    reportee = Reports.get_reportee!(id)
    {:ok, _reportee} = Reports.delete_reportee(reportee)

    conn
    |> put_flash(:info, "Reportee deleted successfully.")
    |> redirect(to: reportee_path(conn, :index))
  end

  def addReportees(conn, reportee_params) do
    {manager_id, ""} = Integer.parse(reportee_params["manager_id"])
    {repotee_id, ""} = Integer.parse(reportee_params["user_id"])
    request_to_add = %{"manager_id" => manager_id, "repotee_id" => repotee_id}
  #  reportee_params = %{"manager_id" => manager_id, "repotee_id" => user_id}
  ismanager = Tasktracker.Accounts.is_manager(manager_id)
  if (ismanager)
  do
    IO.puts("entered else")
    manager_of_manager = Reports.get_user_manager(manager_id)
    IO.puts("checking manager of managers")
    IO.puts(manager_of_manager)
    if (manager_of_manager == repotee_id) do
      conn
      |> put_flash(:error, "you cannot have your manager as your reportee")
      |> redirect(to: reportee_path(conn, :index))
    end
  case Reports.create_reportee(request_to_add) do
     {:ok, reportee} ->
       conn
       |> put_flash(:info, "Reportee created successfully.")
       |> redirect(to: user_path(conn, :show, reportee.manager_id))
     {:error, %Ecto.Changeset{} = changeset} ->
       conn
       |> put_flash(:error, "invalid user id or this employee already has a manager assigned to him/her")
       |> redirect(to: reportee_path(conn, :index))
    end
  else
    conn
    |> put_flash(:error, "you cannot have reportees since you are not manager")
    |> redirect(to: page_path(conn, :index))
  end
end
end
