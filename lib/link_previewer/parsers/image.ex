defmodule LinkPreviewer.Parsers.Image do
  @moduledoc false

  alias LinkPreviewer.Preview

  @spec parse(map) :: %Preview{}
  def parse(%{request_url: request_url}), do: %Preview{image_link: request_url}
end
