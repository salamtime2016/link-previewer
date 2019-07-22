defmodule LinkPreviewer.Parsers.Salamio do
  @moduledoc """
  Salam.io website parser
  """

  use LinkPreviewer.Parser

  @regexp_salamio ~r/.*salam\.io.*/

  def regexp_salamio, do: @regexp_salamio

  @spec parse(map) :: Preview.t()
  def parse(%{request_url: request_url, body: body}) do
    title = body |> Floki.find("title") |> Floki.text() |> String.split("|") |> hd

    %Preview{
      title: title,
      payload: %{username: request_url |> String.split("/") |> List.last()}
    }
  end
end
