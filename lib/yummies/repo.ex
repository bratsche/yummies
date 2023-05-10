defmodule Yummies.Repo do
  use Ecto.Repo,
    otp_app: :yummies,
    adapter: Ecto.Adapters.Postgres
end
