defmodule LinkPreviewer do
  @moduledoc """
  Link parser and previewer
  """

  alias LinkPreviewer.{Error, HttpAdapter}
  alias LinkPreviewer.Parsers.{Html, Image, Opengraph, Salamio, YouTube}
  alias LinkPreviewer.Preview

  @adapter :core |> Application.get_env(__MODULE__, []) |> Keyword.get(:adapter, HttpAdapter)

  @special_cases ~w(salamio youtube)a

  @parsers_processors_mapping %{
    default: [Opengraph, Html],
    image: [Image],
    youtube: [YouTube, Html],
    salamio: [Salamio, Html]
  }

  @doc """
  Parses link and returns the preview
  """
  @spec preview(String.t()) :: {:ok, Preview.t()} | {:error, Error.t()}
  def preview(link) do
    with :ok <- validate_link(link),
         {:ok, response} <- request(link),
         {:ok, processor} <- get_processor(response) do
      preview =
        @parsers_processors_mapping
        |> Map.get(processor)
        |> Enum.map(& &1.parse(response))
        |> Enum.reduce(%Preview{link: link}, &Preview.append(&2, &1))

      {:ok, preview}
    end
  end

  defp validate_link(link) do
    case URI.parse(link) do
      %URI{host: host} when not is_nil(host) ->
        :ok

      _ ->
        {:error, Error.build(:invalid_link, "Invalid link format")}
    end
  end

  defp request(link) do
    case @adapter.get(link) do
      {:ok, %{status_code: 200}} = response ->
        response

      {:ok, %{status_code: status_code}} ->
        {:error, Error.build(:invalid_status_code, "Invalid status code: #{status_code}")}

      {:error, error} ->
        {:error, Error.build(:bad_response, error)}
    end
  end

  defp get_processor(
         %{status_code: 200, headers: %{"Content-Type" => "text/html" <> _}, body: html} = request
       ) do
    with :ok <- validate_format(html) do
      {:ok, handle_special_cases(request) || :default}
    end
  end

  defp get_processor(%{status_code: 200, headers: %{"Content-Type" => "image/" <> _}}) do
    {:ok, :image}
  end

  defp get_processor(
         %{status_code: 200, headers: %{"content-type" => "text/html" <> _}, body: html} = request
       ) do
    with :ok <- validate_format(html) do
      {:ok, handle_special_cases(request) || :default}
    end
  end

  defp get_processor(%{status_code: 200, headers: %{"content-type" => "image/" <> _}}) do
    {:ok, :image}
  end

  defp get_processor(%{status_code: 200}) do
    {:error, Error.build(:unsupported_format)}
  end

  defp handle_special_cases(response), do: Enum.find(@special_cases, &special_case?(&1, response))

  defp special_case?(:youtube, %{request_url: request_url}),
    do: request_url =~ YouTube.regexp_youtube()

  defp special_case?(:salamio, %{request_url: request_url}),
    do: request_url =~ Salamio.regexp_salamio()

  defp special_case?(_special_case, _request), do: false

  defp validate_format(html) do
    case String.valid?(html) do
      true -> :ok
      false -> {:error, Error.build(:invalid_format, "Invalid html format")}
    end
  end
end
