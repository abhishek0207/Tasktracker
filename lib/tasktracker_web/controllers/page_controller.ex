defmodule TasktrackerWeb.PageController do
  use TasktrackerWeb, :controller
  alias Tasktracker.TaskHandler
  alias Tasktracker.TaskHandler.Task
  alias Tasktracker.Accounts

  def index(conn, _params) do
   user_id = get_session(conn, :user_id)
   IO.inspect(user_id)
   if(user_id) do
      redirect(conn, to: page_path(conn, :dashboard))
    else
      render conn, "index.html"
    end

  end

  def dashboard(conn, _params) do
    tasks = TaskHandler.count_tasks()
    users = Accounts.count_users()
    user_id = get_session(conn, :user_id)
    assigned_to_me = TaskHandler.count_incomplete(user_id)
    IO.puts(user_id)
    IO.puts(assigned_to_me)
    #render conn, "dashboard.html"
    if(user_id) do
    render conn, "dashboard.html", tasks: tasks, users: users, assigned: assigned_to_me
  else
    render conn, "index.html"
  end
  end

end
