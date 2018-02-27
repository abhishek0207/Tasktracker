defmodule TasktrackerWeb.UserController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Accounts
  alias Tasktracker.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    current_user = conn.assigns[:current_user]
    if(current_user) do
    render(conn, "index.html", users: users)
  else
    conn
    |> put_flash(:error, "Permission Denied, please login")
    |> redirect(to: page_path(conn, :index))
  end
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    existing = Accounts.get_user_by_email(user_params["email"])
    if(existing) do
      conn
      |> put_flash(:error, "Sorry, but this User already exists. Kindly log in here")
      |> redirect(to: page_path(conn, :index))

  else
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    {id , ""} = Integer.parse(id)
    manager = Tasktracker.Reports.get_user_manager(id)
    #{manager, ""} = Integer.parse(manager)
    if(manager) do
      manager_struct = Accounts.get_user(manager)
      manager_name = manager_struct.name
    else
      manager_name = ""
    end
    if(user) do
      if(user.manager_field == true) do
        reportee_struct = Tasktracker.Reports.get_reportees(id)
        if(reportee_struct) do
        reportee_with_names = Enum.map(reportee_struct, fn(x) -> Accounts.get_user(x) end)
        IO.inspect(reportee_with_names)
      else
        reportee_with_names = []
      end
      end
      render(conn, "show.html", user: user, manager_name: manager_name, reportees: reportee_with_names)
    else
      conn
      |> put_flash(:error, "user does not exist.")
      |> redirect(to: user_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
