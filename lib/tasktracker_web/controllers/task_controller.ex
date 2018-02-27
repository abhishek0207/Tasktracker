defmodule TasktrackerWeb.TaskController do
  use TasktrackerWeb, :controller


  alias Tasktracker.TaskHandler
  alias Tasktracker.TaskHandler.Task


  def index(conn, _params) do
    user_id = get_session(conn, :user_id)
    if(user_id) do
    user = Tasktracker.Accounts.get_user(user_id || -1)
    IO.puts("user is #{user.id}")
    taskPerId = TaskHandler.created_by(user.id)
    assigned_task = TaskHandler.assigned_tasks(user.id)
    timeblockdata=TaskHandler.gettimeMap(user.id)
    IO.puts("time block map is")
    IO.inspect(timeblockdata)
    task_time_info = Enum.map(timeblockdata, fn(x) -> TaskHandler.eachTaskEndTime(x) end)
    task_time_info = List.flatten(task_time_info)
    task_time_info = Enum.reduce(task_time_info, %{}, fn(x, values) ->
    Map.put(values, x["task_id"], x["id"])
    end)
    IO.inspect(task_time_info)
    tasks = TaskHandler.list_tasks()
    render(conn, "index.html", tasks: tasks, taskPerId: taskPerId, tasktime: task_time_info)
  else
    conn
    |> put_flash(:error, "Cannot view Tasks, Please login first")
    |> redirect(to: page_path(conn, :index))
  end
  end

  def new(conn, _params) do
    user_id = get_session(conn, :user_id)
    user = Tasktracker.Accounts.get_user(user_id || -1)
    if(user) do
    changeset = TaskHandler.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  else
    conn
    |> put_flash(:error, "Cannot create Tasks, Please login first")
    |> redirect(to: page_path(conn, :index))
  end
  end

  def create(conn, %{"task" => task_params}) do
    user_id = get_session(conn, :user_id)
    if(user_id) do
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
    else
      conn
      |> put_flash(:error, "Cannot create Tasks, Please login first")
      |> redirect(to: page_path(conn, :index))
end
  end

  def show(conn, %{"id" => id}) do
    user_id = get_session(conn, :user_id)
    timeblocks = TaskHandler.getTaskTimeblocks(id)
    IO.inspect(timeblocks)
    if(user_id) do
    task = TaskHandler.get_task(id)
    if(task) do
      render(conn, "show.html", task: task, timeblocks: timeblocks)
    else
      conn
      |> put_flash(:error, "Task does not exist")
      |> redirect(to: task_path(conn, :index))
    end

  else
    conn
    |> put_flash(:error, "Cannot view a task, Please login first")
    |> redirect(to: page_path(conn, :index))
  end
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

  def generateTaskReport(conn, _params) do
    current_user = conn.assigns[:current_user]
    if(current_user) do
    managercheck = Tasktracker.Accounts.is_manager(current_user.id)
    if (managercheck) do
    assigned_task = TaskHandler.assigned_tasks(current_user.id)
    IO.inspect(assigned_task)
    render(conn, "taskReport.html", assigned_task: assigned_task)
  else
    conn
    |>put_flash(:error, "permission denied")
    |>redirect(to: page_path(conn, :index))
  end
  else
    conn
    |> put_flash(:error, "Cannot view Tasks, Please login first")
    |> redirect(to: page_path(conn, :index))
  end
  end

end
