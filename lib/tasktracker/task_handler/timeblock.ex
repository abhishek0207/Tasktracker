defmodule Tasktracker.TaskHandler.Timeblock do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.TaskHandler.Timeblock


  schema "timeblocks" do
    belongs_to :task, Tasktracker.TaskHandler.Task, foreign_key: :task_id
    belongs_to :user, Tasktracker.Accounts.User, foreign_key: :user_id
    field :end_time, :naive_datetime
    field :start_time, :naive_datetime
    timestamps()
  end

  @doc false
  def changeset(%Timeblock{} = timeblock, attrs) do
    timeblock
    |> cast(attrs, [:start_time, :end_time, :task_id, :user_id])
  end
end
