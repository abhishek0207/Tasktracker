defmodule TasktrackerWeb.Router do
  use TasktrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TasktrackerWeb.Sessionplug
    plug TasktrackerWeb.Dropdownplug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TasktrackerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/dashboard", PageController, :dashboard
    post "/updateTaskTime", TaskController, :updateTime
    post "/addReportees", ReporteeController, :addReportees
    get "/myResources", ReporteeController, :get_reportees
    get "/taskReport", TaskController, :generateTaskReport
    resources "/users", UserController
    resources "/tasks", TaskController
    resources "/reportees", ReporteeController
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete


  end

  # Other scopes may use custom stacks.
  scope "/api/v1", TasktrackerWeb do
     pipe_through :api
       resources "/timeblocks", TimeblockController, except: [:new, :edit]
   end
end
