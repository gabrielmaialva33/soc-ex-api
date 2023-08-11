defmodule SocExApiWeb.MetaJSON do
  @moduledoc """
  Renders metadata.
  """

  def render(meta) do
    data(meta)
  end

  defp data(%{} = meta) do
    meta
  end
end
