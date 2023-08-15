defmodule SocExApi.Helpers do
  @moduledoc """
  Helper functions for SocExApi application context.
  """

  @paging_opts ~w(page page_size search order_by order_directions)

  @doc """
  Parses pagination params from a map.
  ### Examples
      iex> SocExApi.Helpers.parse_pagination_params(%{"order_by" => "id, name", "order_directions" => "asc, desc"})
      %{order_by: [:id, :name], order_directions: [:asc, :desc]}
  """
  def parse_pagination_params(params) do
    params
    |> Map.take(@paging_opts)
    |> keys_to_atoms()
    |> parse_order_by()
    |> parse_order_directions()
  end

  def keys_to_atoms(json) when is_map(json) do
    Map.new(json, &reduce_keys_to_atoms/1)
  end

  def reduce_keys_to_atoms({key, val}) when is_map(val),
    do: {String.to_existing_atom(key), keys_to_atoms(val)}

  def reduce_keys_to_atoms({key, val}) when is_list(val),
    do: {String.to_existing_atom(key), Enum.map(val, &keys_to_atoms(&1))}

  def reduce_keys_to_atoms({key, val}), do: {String.to_existing_atom(key), val}

  defp parse_order_by(opts) do
    if Map.has_key?(opts, :order_by) do
      opts
      |> Map.update!(:order_by, &parse_order(&1))
    else
      opts
    end
  end

  defp parse_order_directions(opts) do
    if Map.has_key?(opts, :order_directions) do
      opts
      |> Map.update!(:order_directions, &parse_order(&1))
    else
      opts
    end
  end

  defp parse_order(order) do
    order
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_atom/1)
  end
end
