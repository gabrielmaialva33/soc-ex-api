#!/usr/bin/env bash

# Wait until Postgres is ready.
while ! pg_isready -q -h "$PG_HOSTNAME" -p "$PG_PORT" -U "$PG_USER"
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Create, migrate, and seed database if it doesn't exist.
echo "$(date) - create database if not exists"
mix ecto.create
echo "$(date) - migrate database"
mix ecto.migrate
echo "$(date) - seed database"
mix run priv/repo/seeds.exs
echo "$(date) - start server"
exec mix phx.server