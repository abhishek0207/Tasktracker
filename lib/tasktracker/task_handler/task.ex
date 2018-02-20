defmodule Tasktracker.TaskHandler.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.TaskHandler.Task


  schema "tasks" do
    field :title, :string
    field :body, :string
    field :status, :boolean, default: false
    belongs_to :creator, Tasktracker.Accounts.User, foreign_key: :createdBy_id
    belongs_to :assigner, Tasktracker.Accounts.User, foreign_key: :assignedTo_id
    field :time_taken, :integer, default: 0
    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title,:body, :status, :createdBy_id, :assignedTo_id, :time_taken])
    |> validate_required([:title, :body, :status, :createdBy_id])
    |> validate_time(:time_taken)

  end

  def validate_time(changeset, field, options \\ []) do
  validate_change(changeset, field, fn _, time_taken ->
  case rem(time_taken, 15)==0 do
      false -> [{field, options[:message] || "You can only add time in the increments of 15 minutes"}]
      true -> []
    end
  end)
end


end
