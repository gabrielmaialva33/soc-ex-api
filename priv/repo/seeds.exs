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

# create many users
alias SocExApi.Repo
alias SocExApi.Accounts.User

Enum.map(1..100, fn _ ->
  %User{
    username: Faker.Internet.user_name(),
    first_name: Faker.Person.first_name(),
    last_name: Faker.Person.last_name(),
    email: Faker.Internet.email(),
    password_hash: Argon2.hash_pwd_salt("12345678"),
    is_online: Faker.random_uniform() > Faker.random_uniform(),
    is_deleted: Faker.random_uniform() > Faker.random_uniform()
  }
  |> Repo.insert!()
end)
