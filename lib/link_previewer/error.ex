defmodule LinkPreviewer.Error do
  @moduledoc false

  @enforce_keys ~w(exception)a
  defstruct ~w(exception message)a

  @type t :: %__MODULE__{
          exception: atom,
          message: String.t() | nil
        }

  @spec build(atom) :: t
  @spec build(atom, String.t() | nil) :: t
  def build(exception, message \\ nil), do: %__MODULE__{exception: exception, message: message}
end
