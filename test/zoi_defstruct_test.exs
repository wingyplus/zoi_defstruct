defmodule ZoiDefstructTest do
  use ExUnit.Case
  doctest ZoiDefstruct

  defmodule A do
    use ZoiDefstruct

    @schema Zoi.object(%{
              name: Zoi.string()
            })

    defstructure(@schema)
  end

  test "define struct keys" do
    %A{name: "hello"}
  end

  test "struct enforce keys" do
    assert_raise ArgumentError, fn ->
      struct!(A, [])
    end
  end

  defmodule MixedRequiredOptional do
    use ZoiDefstruct

    @schema Zoi.object(%{
              name: Zoi.string(),
              age: Zoi.integer() |> Zoi.optional()
            })

    defstructure(@schema)
  end

  test "mixed required and optional" do
    assert %MixedRequiredOptional{age: nil} = %MixedRequiredOptional{name: "Hello"}
  end

  defmodule DefaultValue do
    use ZoiDefstruct

    @schema Zoi.object(%{
              tax_rate: Zoi.integer() |> Zoi.default(7)
            })

    defstructure(@schema)
  end

  test "default value" do
    assert %DefaultValue{tax_rate: 7} = %DefaultValue{}
  end
end
