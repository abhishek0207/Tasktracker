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
    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title,:body, :status, :createdBy_id, :assignedTo_id])
    |> validate_required([:title, :body, :status, :createdBy_id])

  end

end
