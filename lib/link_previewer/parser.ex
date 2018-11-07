defmodule LinkPreviewer.Parser do
  @moduledoc false

  alias LinkPreviewer.Preview

  @callback parse(map) :: Preview.t()

  defmacro __using__(_opts) do
    quote do
      alias LinkPreviewer.Preview

      @behaviour LinkPreviewer.Parser
    end
  end
end
