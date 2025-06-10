defmodule Bywater.Repo do
  use Ecto.Repo,
    otp_app: :bywater,
    adapter: Ecto.Adapters.SQLite3
end
