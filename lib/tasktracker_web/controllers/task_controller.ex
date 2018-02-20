defmodule TasktrackerWeb.TaskController do
  use TasktrackerWeb, :controller

  alias Tasktracker.TaskHandler
  alias Tasktracker.TaskHandler.Task

  plug :get_current_user
  plug :get_user_for_dropdown

def get_current_user(conn, _params) do
  # TODO: Move this function out of the router module.
  user_id = get_session(conn, :user_id)
  IO.inspect(conn)
  user = Tasktracker.Accounts.get_user(user_id || -1)
    assign(conn, :current_user, user)

end

def get_user_for_dropdown(conn,  _params) do
  user = Tasktracker.TaskHandler.getSelectData()
    assign(conn, :assigners, user)
end

  def index(conn, _params) do
    user_id = get_session(conn, :user_id)
    user = Tasktracker.Accounts.get_user(user_id || -1)
    IO.puts("user is #{user.id}")
    taskPerId = TaskHandler.created_by(user.id)
    tasks = TaskHandler.list_tasks()
    render(conn, "index.html", tasks: tasks, taskPerId: taskPerId)
  end

  def new(conn, _params) do
    user_id = get_session(conn, :user_id)
    user = Tasktracker.Accounts.get_user(user_id || -1)
    if(user) do
    changeset = TaskHandler.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  else
    conn
    |> put_flash(:info, "Cannot create Tasks, Please login first")
    |> redirect(to: page_path(conn, :index))
  end
  end

  def create(conn, %{"task" => task_params}) do
      assigners = TaskHandler.getSelectData()
      case TaskHandler.create_task(task_params) do
        {:ok, task} ->
          conn
          |> put_flash(:info, "Task created successfully.")
          |> redirect(to: task_path(conn, :show, task))
        {:error, %Ecto.Changeset{} = changeset} ->
          IO.inspect(changeset)
          render(conn, "new.html", changeset: changeset)
      end

  end

  def show(conn, %{"id" => id}) do
    task = TaskHandler.get_task!(id)
    render(conn, "show.html", task: task)
  end


  def edit(conn, %{"id" => id}) do
    task = TaskHandler.get_task!(id)
    changeset = TaskHandler.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = TaskHandler.get_task!(id)
    IO.puts("task is")
    IO.inspect(task_params)
    if(task_params["status"] == "true" && task_params["time_taken"] == "0") do
      conn
      |> put_flash(:error, "Please update the time taken to complete this task")
      |> render("show.html", task: task)
    else
      case TaskHandler.update_task(task, task_params) do
        {:ok, task} ->
          conn
          |> put_flash(:info, "Task updated successfully.")
          |> redirect(to: task_path(conn, :show, task))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", task: task, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    task = TaskHandler.get_task!(id)
    {:ok, _task} = TaskHandler.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: task_path(conn, :index))
  end

  def updateTime(conn, %{"task_id" => task_id, "time_taken" => time_taken})
  do
    task = TaskHandler.get_task!(task_id)
    case TaskHandler.update_task(task, %{time_taken: time_taken}) do
    {:ok, task} ->
      conn
      |> put_flash(:info, "Task updated successfully.")
      |> redirect(to: task_path(conn, :show, task))
    {:error, %Ecto.Changeset{} = changeset} ->
      conn
      |> put_flash(:error, "Time can be updated only in the intervals of 15 minutes")
      |> redirect(to: task_path(conn, :show, task))
    end

  end


end
