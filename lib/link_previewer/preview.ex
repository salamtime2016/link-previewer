defmodule LinkPreviewer.Preview do
  @moduledoc false

  defstruct ~w(description icon_link image_link link title payload)a

  @type t :: %__MODULE__{
          description: String.t() | nil,
          icon_link: String.t() | nil,
          image_link: String.t() | nil,
          link: String.t(),
          payload: map | nil,
          title: String.t() | nil
        }

  @spec append(t, t) :: t
  def append(%__MODULE__{} = first_preview, %__MODULE__{} = second_preview),
    do: Map.merge(first_preview, second_preview, &resolve_conflict/3)

  defp resolve_conflict(_key, nil, value2), do: value2
  defp resolve_conflict(_key, "", value2), do: value2
  defp resolve_conflict(_key, value1, _value2), do: value1
end
