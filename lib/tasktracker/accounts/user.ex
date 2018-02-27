defmodule Tasktracker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Accounts.User


  schema "users" do
    field :email, :string
    field :name, :string
    field :manager_field, :boolean
    has_many :reportees_follows, Tasktracker.Reports.Reportee, foreign_key: :repotee_id
    has_many :reportees, through: [:reportees_follows, :reportee]
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do

    user
    |> cast(attrs, [:email, :name, :manager_field])
    |> validate_required([:email, :name])
    |> validate_format(:email,~r/@/)
    |> unique_constraint(:email)

  end
end
