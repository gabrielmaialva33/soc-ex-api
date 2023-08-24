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

# create 100 users
Enum.map(1..100, fn _ ->
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
alias SocExApi.Accounts.Role

Enum.map(["root", "admin", "user"], fn name ->
  %Role{name: name, slug: name |> String.upcase()}
  |> Repo.insert!()
end)

# create user roles
alias SocExApi.Accounts.UserRole

# get all users
users = Repo.all(User)

# get user role
user_role = Role |> Repo.get_by(name: "user")

# attach user role to all users
Enum.map(users, fn user ->
  %UserRole{user_id: user.id, role_id: user_role.id}
  |> Repo.insert!()
end)


# create default users
# root, admin
Enum.map(["root", "admin"], fn name ->
  %User{
    username: name,
    first_name: name |> String.capitalize(),
    last_name: name |> String.capitalize() |> String.reverse(),
    # email is the same as username + @ + domain `.alucard.fun`
    email: name <> "@alucard.fun",
    password_hash: Argon2.hash_pwd_salt("Soc@551238"),
    avatar_url: "https://api.multiavatar.com/#{name}.svg",
  }
  |> Repo.insert!()
end)

# get root user
root_user = User |> Repo.get_by(username: "root")
root_role = Role |> Repo.get_by(name: "root")

# attach root role to root user
%UserRole{user_id: root_user.id, role_id: root_role.id}

# get admin user
admin_user = User |> Repo.get_by(username: "admin")
admin_role = Role |> Repo.get_by(name: "admin")

# attach admin role to admin user
%UserRole{user_id: admin_user.id, role_id: admin_role.id}
