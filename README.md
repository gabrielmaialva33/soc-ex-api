<h1 align="center">
  <br>
  <img src="https://raw.githubusercontent.com/gabrielmaialva33/soc-ex-api/master/.github/assets/potion.png" alt="Soc Ex Api" width="200">
  <br>
  A Social Network in <a href="https://www.phoenixframework.org/">Phoenix</a>
  <br>
</h1>

<p align="center">
  <img src="https://wakatime.com/badge/user/e61842d0-c588-4586-96a3-f0448a434be4/project/f9fe6f35-e425-406b-ad3d-460da80858f8.svg" alt="wakatime">
  <img src="https://img.shields.io/github/languages/top/gabrielmaialva33/soc-ex-api?style=flat&logo=appveyor" alt="GitHub top language" >
  <img src="https://img.shields.io/github/languages/count/gabrielmaialva33/soc-ex-api?style=flat&logo=appveyor" alt="GitHub language count" >
  <img src="https://img.shields.io/github/repo-size/gabrielmaialva33/soc-ex-api?style=flat&logo=appveyor" alt="Repository size" >
  <img src="https://img.shields.io/github/license/gabrielmaialva33/soc-ex-api?color=00b8d3?style=flat&logo=appveyor" alt="License" /> 
  <a href="https://github.com/gabrielmaialva33/soc-ex-api/commits/master">
    <img src="https://img.shields.io/github/last-commit/gabrielmaialva33/soc-ex-api?style=flat&logo=appveyor" alt="GitHub last commit" >
    <img src="https://img.shields.io/badge/made%20by-Maia-15c3d6?style=flat&logo=appveyor" alt="Maia" >  
  </a>
</p>

<p align="center">
  <a href="#bookmark-about">About</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#computer-technologies">Technologies</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#package-installation">Installation</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#wrench-configuration">Configuration</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#memo-documentation">Documentation</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#memo-license">License</a>
</p>

<br>

## :bookmark: About

**Soc Ex** is a social experiment that uses the [Phoenix](https://www.phoenixframework.org/) framework to create an API.

<br>

## :computer: Technologies

- **[Elixir](https://elixir-lang.org/)**
- **[Phoenix](https://www.phoenixframework.org/)**
- **[Docker](https://www.docker.com/)**
- **[PostgreSQL](https://www.postgresql.org/)**

## :package: Installation

```bash
# clone the repository
git clone https://github.com/gabrielmaialva33/soc-ex-api.git
# enter the directory
cd soc-ex-api
# install the dependencies
mix deps.get # or mix deps.get --only prod
# edit `config/dev.exs` and configure your database or use the environment variables
nano config/dev.exs # or vim config/dev.exs
# run the database migrations
mix ecto.setup # or mix ecto.setup --only prod
# start the server
mix phx.server # or mix phx.server --only prod
```

### :wrench: **Configuration**

open the `config/dev.exs` file and configure your database

```elixir
# Configure your database
config :soc_ex_api, SocExApi.Repo,
  username: "postgres",
  password: "postgres",
  database: "soc_ex_api_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

### :memo: **Documentation**

```md
# Use insomnia or postman to test the routes

file `soc-ex-api.yaml` in root directory
```

### :writing_hand: **Author**

| [![Maia](https://avatars.githubusercontent.com/u/26732067?size=100)](https://github.com/gabrielmaialva33) |
|-----------------------------------------------------------------------------------------------------------|
| [Maia](https://github.com/gabrielmaialva33)                                                               |

## License

[MIT License](./LICENSE)
