defmodule SocExApi.Factory do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SocExApi` context.
  """

  use ExMachina.Ecto, repo: MyApp.Repo
  use SocExApi.UserFactory
end
