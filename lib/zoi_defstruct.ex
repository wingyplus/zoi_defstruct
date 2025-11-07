defmodule ZoiDefstruct do
  @moduledoc """
  `ZoiDefstruct` helps you define a struct from a `Zoi` object schema.

  ## Define a struct

  Once you add a `use ZoiDefstruct`, you can define a struct using `defstruct` with the
  schema like example below:

      defmodule Person do
        use ZoiDefstruct

        defstruct name: Zoi.string(), age: Zoi.integer()
      end

  ## Using with another struct

  `ZoiDefstruct` generates a function `t/0` that returns a `Zoi` schema so you can
  use it in other structs. Let's enhance the example above to add an address to the `Person` struct:

      defmodule Address do
        use ZoiDefstruct

        defstruct address_line1: Zoi.string(), city: Zoi.string()
      end

      defmodule Person do
        use ZoiDefstruct

        defstruct name: Zoi.string(), age: Zoi.integer(), address: Address.t()
      end
  """

  import Kernel, except: [defstruct: 1]

  @doc """
  Define a struct from `Zoi` schema.

  ## Examples

      defmodule Person do
        use ZoiDefstruct

        defstruct name: Zoi.string(), age: Zoi.integer()
      end
  """
  defmacro defstruct(fields) do
    quote location: :keep, bind_quoted: [fields: fields] do
      import ZoiDefstruct, except: [defstruct: 1]
      import Kernel

      @struct Zoi.struct(__MODULE__, fields)

      @type t :: unquote(Zoi.type_spec(@struct))

      @enforce_keys Zoi.Struct.enforce_keys(@struct)
      defstruct Zoi.Struct.struct_fields(@struct)

      def t(), do: @struct
    end
  end

  defmacro __using__(_) do
    quote do
      import Kernel, except: [defstruct: 1]
      import ZoiDefstruct, only: [defstruct: 1]
    end
  end
end
