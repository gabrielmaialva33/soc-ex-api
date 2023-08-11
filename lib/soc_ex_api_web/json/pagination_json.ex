defmodule SocExApiWeb.PaginationJSOM do
  @moduledoc """
  Renders pagination metadata. (Flop metadata)
  """

  def render(meta) do
    data(meta)
  end

  defp data(%Flop.Meta{} = meta) do
    %{
      total_pages: meta.total_pages,
      total_count: meta.total_count,
      current_page: meta.current_page,
      page_size: meta.page_size,
      next_page: meta.next_page,
      previous_page: meta.previous_page,
      has_next_page: meta.has_next_page?,
      has_previous_page: meta.has_previous_page?,
      start_cursor: meta.start_cursor,
      end_cursor: meta.end_cursor
    }
  end
end
