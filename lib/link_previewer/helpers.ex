defmodule LinkPreviewer.Helpers do
  @moduledoc false

  @spec normalize_link(String.t(), String.t()) :: String.t() | nil
  def normalize_link(_base_link, nil), do: nil
  def normalize_link(base_link, link), do: base_link |> URI.merge(link) |> to_string()
end
