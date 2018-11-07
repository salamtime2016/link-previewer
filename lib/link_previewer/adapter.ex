defmodule LinkPreviewer.Adapter do
  @moduledoc false

  @type error :: String.t()
  @type link :: String.t()
  @type response :: %{
          status_code: non_neg_integer,
          body: String.t(),
          headers: map(),
          request_url: String.t()
        }

  @callback get(link) :: {:ok, response} | {:error, error}

  defmacro __using__(_opts) do
    quote do
      @behaviour LinkPreviewer.Adapter

      @type error :: LinkPreviewer.Adapter.error()
      @type link :: LinkPreviewer.Adapter.link()
      @type response :: LinkPreviewer.Adapter.response()
    end
  end
end
