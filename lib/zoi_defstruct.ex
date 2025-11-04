defmodule ZoiDefstruct do
  @moduledoc """
  `ZoiDefstruct` help you define from `Zoi` object schema.

  ## Examples

      defmodule Person do
        use ZoiDefstruct
      
        @schema Zoi.object(%{name: Zoi.string(), age: Zoi.integer()})
      
        defstructure(@schema)
      end
      
      %Person{name: "hello"}
  """

  @doc """
  Define a struct from Zoi schema.
  """
  defmacro defstructure(schema) do
    quote location: :keep do
      defstruct ZoiDefstruct.struct_keys(unquote(schema))
    end
  end

  defmacro __using__(_) do
    quote do
      import ZoiDefstruct
    end
  end

  # Convert object into struct keys.
  @doc false
  def struct_keys(%Zoi.Types.Object{fields: fields}) do
    fields
    |> Enum.map(fn {key, _} -> key end)
  end
end
