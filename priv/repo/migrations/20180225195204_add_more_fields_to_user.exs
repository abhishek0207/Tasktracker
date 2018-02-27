defmodule Tasktracker.Repo.Migrations.AddMoreFieldsToUser do
  use Ecto.Migration

  def change do
    alter table (:tasks) do
      add :start_time, :naive_datetime
      add :end_time,   :naive_datetime
      remove :time_taken
  end
end
end
