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
alias SocExApi.Accounts.Role
alias SocExApi.Accounts.UserRole

Repo.delete_all(UserRole)
Repo.delete_all(User)

# create users
Enum.map(1..20, fn _ ->
  first_name = Faker.Person.first_name()
  last_name = Faker.Person.last_name()

  %User{
    username: Faker.Internet.user_name(),
    first_name: first_name,
    last_name: last_name,
    email: Faker.Internet.email(),
    password_hash: Argon2.hash_pwd_salt("Soc@551238"),
    avatar_url: "https://api.multiavatar.com/#{first_name}#{last_name}.svg",
    is_online: Faker.random_uniform() > Faker.random_uniform(),
    is_deleted: Faker.random_uniform() < Faker.random_uniform()
  }
  |> Repo.insert!()
end)

# create roles
Enum.map(["root", "admin", "user"], fn name ->
  if Role |> Repo.get_by(name: name) == nil do
    %Role{name: name, slug: name |> String.upcase()}
    |> Repo.insert!()
  end
end)

# set default role for all users
users = Repo.all(User)
user_role = Role |> Repo.get_by(name: "user")

Enum.map(users, fn user ->
  %UserRole{user_id: user.id, role_id: user_role.id}
  |> Repo.insert!()
end)


# create default users
Enum.map(["root", "admin"], fn name ->
  user = %User{
    username: name,
    first_name: name |> String.capitalize(),
    last_name: name |> String.capitalize() |> String.reverse(),
    email: name <> "@alucard.fun",
    password_hash: Argon2.hash_pwd_salt("Soc@551238"),
    avatar_url: "https://api.multiavatar.com/#{name}.svg",
  }
  |> Repo.insert!()

  user_role = Role |> Repo.get_by(name: name)

  %UserRole{user_id: user.id, role_id: user_role.id} |> Repo.insert!()
end)
