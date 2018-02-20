defmodule TasktrackerWeb.Router do
  use TasktrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :get_current_user
    plug :get_user_for_dropdown
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

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

  scope "/", TasktrackerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/dashboard", PageController, :dashboard
    post "/updateTaskTime", TaskController, :updateTime
    resources "/users", UserController
    resources "/tasks", TaskController
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", TasktrackerWeb do
  #   pipe_through :api
  # end
end
