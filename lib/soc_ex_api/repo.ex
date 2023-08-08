defmodule SocExApi.Repo do
  use Ecto.Repo,
    otp_app: :soc_ex_api,
    adapter: Ecto.Adapters.Postgres
end
