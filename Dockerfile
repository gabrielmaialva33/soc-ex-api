# Use an official Elixir runtime as a parent image
FROM elixir:latest
LABEL maintainer="Gabriel Maia <gabrielmaialva33@gmail.com>"

# Install postgresql-client for migrations
RUN apt-get update && apt-get install -y postgresql-client

# Install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# Copy the current directory contents into the container
COPY . .

# Set build ENV
ENV MIX_ENV=docker

# Install dependencies
RUN mix deps.get && mix deps.compile

# Compile the project
RUN mix compile

# Set and expose PORT environmental variable
ENV PORT ${PORT:-4000}
EXPOSE $PORT

# Run entrypoint
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]