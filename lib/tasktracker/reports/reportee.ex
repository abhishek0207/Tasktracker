defmodule Tasktracker.Reports.Reportee do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Reports.Reportee


  schema "reportees" do
    belongs_to :manager, Tasktracker.Accounts.User, foreign_key: :manager_id
    belongs_to :reportee, Tasktracker.Accounts.User, foreign_key: :repotee_id
    timestamps()
  end

  @doc false
  def changeset(%Reportee{} = reportee, attrs) do
    reportee
    |> cast(attrs, [:manager_id, :repotee_id])
    |> validate_required([:manager_id, :repotee_id])
    |> unique_constraint(:unique_repotee_id, name: :unique_index_for_repotee_id)
    |> unique_constraint(:unique_manager_reportee, name: :unique_indexes_for_reportees)
    |> foreign_key_constraint(:manager_id)
    |> foreign_key_constraint(:repotee_id)
  end
end
