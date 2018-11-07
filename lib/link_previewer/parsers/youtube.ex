defmodule LinkPreviewer.Parsers.YouTube do
  @moduledoc """
  Generates youtube preview links with images
  """
  use LinkPreviewer.Parser

  @regexp_youtube ~r/(youtu\.be\/|youtube\.com\/(watch\?(.*&)?v=|(embed|v)\/))([^\?&"'>]+)/
  @image_host "https://i.ytimg.com/vi"

  @spec regexp_youtube :: %Regex{
          :opts => <<>>,
          :re_pattern => {:re_pattern, 5, 0, 0, <<_::1848>>},
          :re_version => {<<_::120>>, :little},
          :source => <<_::528>>
        }

  def regexp_youtube, do: @regexp_youtube

  @spec parse(map) :: Preview.t()
  def parse(%{request_url: request_url, body: body}) do
    id = @regexp_youtube |> Regex.scan(request_url) |> List.flatten() |> List.last()

    %Preview{
      icon_link: icon_link(id),
      image_link: image_link(id),
      link: request_url,
      title: parse_title(body)
    }
  end

  defp image_link(id), do: @image_host <> "/#{id}/hqdefault.jpg"
  defp icon_link(id), do: @image_host <> "/#{id}/default.jpg"

  defp parse_title(body) do
    case Regex.run(~r/"title":"([^"]+)".+/, body) do
      [_, title] -> title
      _ -> "YouTube link"
    end
  end
end
