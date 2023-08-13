defmodule SocExApi.Factory do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SocExApi` context.
  """

  use ExMachina.Ecto, repo: SocExApi.Repo
  use SocExApi.UserFactory
end
