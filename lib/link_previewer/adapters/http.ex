defmodule LinkPreviewer.HttpAdapter do
  @moduledoc false

  use LinkPreviewer.Adapter

  alias HTTPoison.Error
  alias LinkPreviewer.HttpWrapper

  # TODO move user_agent and ip to adapter's config
  @user_agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 \
(KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36"
  @ip "64.233.160.0"
  @max_redirect 3

  @spec get(link) :: {:ok, response} | {:error, error}
  def get(link) do
    with {:ok, response} <-
           HttpWrapper.get(link, headers(), follow_redirect: true, max_redirect: @max_redirect) do
      {:ok, Map.take(response, ~w(status_code request_url body headers)a)}
    else
      {:error, error} -> {:error, Error.message(error)}
    end
  end

  defp headers, do: ["User-Agent": @user_agent, "X-Forwarded-For": @ip]
end
