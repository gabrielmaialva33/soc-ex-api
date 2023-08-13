# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SocExApi.Repo.insert!(%SocExApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias SocExApi.Repo
alias SocExApi.Accounts.User

SocExApi.Repo.insert!(%User{
  first_name: "John",
  last_name: "Doe",
  email: "
