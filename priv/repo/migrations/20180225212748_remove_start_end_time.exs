defmodule Tasktracker.Repo.Migrations.RemoveStartEndTime do
  use Ecto.Migration

  def change do
    alter table (:tasks) do
      remove :end_time
      remove :start_time
  end
  end
end
