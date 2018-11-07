defmodule LinkPreviewer.Parsers.Opengraph do
  @moduledoc false

  use LinkPreviewer.Parser
  import LinkPreviewer.Helpers, only: [normalize_link: 2]
  alias LinkPreviewer.Preview

  @spec parse(map) :: Preview.t()
  def parse(%{request_url: request_url, body: html}) do
    property_finder = property_finder(html)

    %Preview{
      description: property_finder.("og:description"),
      title: property_finder.("og:title"),
      image_link: normalize_link(request_url, property_finder.("og:image")),
      link: request_url
    }
  end

  defp property_finder(html) do
    parsed_html = Floki.parse(html)

    fn property ->
      parsed_html
      |> Floki.find("meta[property^='#{property}']")
      |> Floki.attribute("content")
      |> List.first()
      |> blank_to_nil()
    end
  end

  defp blank_to_nil(""), do: nil
  defp blank_to_nil(value), do: value
end
