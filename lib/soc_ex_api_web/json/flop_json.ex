defmodule SocExApiWeb.FlopJSON do
  @moduledoc """
  JSON serialization for Flop.
  """

  @doc """
  Serializes a flop validation error.
  """
  def render("error.json", %{meta: meta}) do
    %{
      message: "Invalid query parameters",
      errors: format_errors(meta.errors)
    }
  end

  defp format_errors(errors) do
    Enum.flat_map(errors, fn {field, error_list} ->
      Enum.map(error_list, fn {message, details} ->
        %{field: field, message: format_message(message, details)}
      end)
    end)
  end

  defp format_message(message, details) do
    String.replace(message, "%{number}", fn _ -> get_number(details) end)
  end

  defp get_number(details) do
    case List.first(Enum.filter(details, fn {key, _} -> key == :number end)) do
      nil ->
        ""

      {:number, value} ->
        Integer.to_string(value)
    end
  end
end
