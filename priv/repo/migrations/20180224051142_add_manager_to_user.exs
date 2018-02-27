defmodule Tasktracker.Repo.Migrations.AddManagerToUser do
  use Ecto.Migration

  def change do
    alter table (:users) do
      add :manager_field, :boolean
    end

  end
end
