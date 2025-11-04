defmodule ZoiDefstruct do
  @moduledoc """
  `ZoiDefstruct` helps you define a struct from a `Zoi` object schema.

  ## Getting Started

  Once you have a schema defined in the module, call `use ZoiDefstruct` and then
  call `defstructure/1` to generate a struct:

      defmodule Person do
        use ZoiDefstruct

        @schema Zoi.object(%{
                  name: Zoi.string(),
                  age: Zoi.integer()
                })

        defstructure(@schema)
      end

      # Usage
      person = %Person{name: "Alice", age: 30}

  ## What gets generated

  When `defstructure/1` is called, the macro generates:

  - A struct definition via `defstruct` with fields from the schema.
  - Default values for any fields defined with `Zoi.default/2`.
  - Enforced keys (via `@enforce_keys`) for required fields that don't have default values.
  - Generate the Typespec type `t()` from the schema.
  """

  alias Zoi.Types.Object, as: ZO
  alias Zoi.Types.Default, as: ZD

  @doc """
  Define a struct from `Zoi` schema.
  """
  defmacro defstructure(schema) do
    quote location: :keep, bind_quoted: [schema: schema] do
      @type t :: unquote(Zoi.type_spec(schema))

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
