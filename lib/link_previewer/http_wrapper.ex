defmodule LinkPreviewer.HttpWrapper do
  @moduledoc false

  use HTTPoison.Base

  @spec process_headers(HTTPoison.Base.headers()) :: HTTPoison.Base.headers()
  def process_headers(headers) do
    Enum.reduce(headers, %{}, fn {key, value}, acc -> Map.put_new(acc, key, value) end)
  end
end
