defmodule LinkPreviewer.Parsers.Html do
  @moduledoc false

  use LinkPreviewer.Parser

  import LinkPreviewer.Helpers, only: [normalize_link: 2]

  @spec parse(map) :: Preview.t()
  def parse(%{body: html, request_url: request_url}) do
    parsed_html = Floki.parse(html)

    %Preview{
      description: description(parsed_html),
      icon_link: normalize_link(request_url, icon_link(parsed_html)),
      image_link: normalize_link(request_url, image_link(parsed_html)),
      link: request_url,
      title: title(parsed_html)
    }
  end

  defp title(parsed_html) do
    parsed_html |> Floki.find("head title") |> Floki.text() |> String.trim()
  end

  defp description(parsed_html) do
    parsed_html
    |> Floki.find("head meta[name='description']")
    |> Floki.attribute("content")
    |> List.first()
  end

  defp image_link(parsed_html) do
    parsed_html
    |> Floki.find("head link[rel='image_src']")
    |> Floki.attribute("href")
    |> List.first()
  end

  defp icon_link(parsed_html) do
    parsed_html
    |> Floki.find("head link[rel|='apple-touch-icon']")
    |> Floki.attribute("href")
    |> List.first()
  end
end
