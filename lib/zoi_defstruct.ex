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

  alias Zoi.Types.Object, as: ZO
  alias Zoi.Types.Default, as: ZD

  @doc """
  Define a struct from Zoi schema.
  """
  defmacro defstructure(schema) do
    quote location: :keep do
      schema = unquote(schema)
      enforce_keys = ZoiDefstruct.struct_enforce_keys(schema)

      if enforce_keys != [] do
        @enforce_keys enforce_keys
      end

      defstruct ZoiDefstruct.struct_keys(schema)
    end
  end

  defmacro __using__(_) do
    quote do
      import ZoiDefstruct
    end
  end

  # Convert object into struct keys.
  @doc false
  def struct_keys(%ZO{fields: fields}) do
    fields
    |> Enum.map(&with_name_and_optional/1)
  end

  def struct_enforce_keys(%ZO{fields: fields}) do
    fields
    |> Enum.filter(&required?/1)
    |> Enum.map(&with_name/1)
  end

  defp with_name_and_optional({name, %ZD{value: value}}), do: {name, value}
  defp with_name_and_optional({name, _}), do: name

  defp with_name({name, _}), do: name

  defp required?({_, %ZD{}}), do: false
  defp required?({_, schema}), do: schema.meta.required
end
