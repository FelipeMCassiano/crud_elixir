defmodule CrudLive.Repo do
  use Ecto.Repo,
    otp_app: :crud_live,
    adapter: Ecto.Adapters.Postgres
end
