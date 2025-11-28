defmodule ZoiDefstructTest do
  use ExUnit.Case
  doctest ZoiDefstruct

  defmodule A do
    use ZoiDefstruct

    defstruct name: Zoi.string()
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

    defstruct name: Zoi.string(), age: Zoi.integer() |> Zoi.optional()
  end

  test "mixed required and optional" do
    assert %MixedRequiredOptional{age: nil} = %MixedRequiredOptional{name: "Hello"}
  end

  defmodule DefaultValue do
    use ZoiDefstruct

    # Zoi will convert to required field when calling `default` after `optional`.
    defstruct tax_rate: Zoi.integer() |> Zoi.default(7) |> Zoi.optional()
  end

  test "default value" do
    assert %DefaultValue{tax_rate: 7} = %DefaultValue{}
  end

  defmodule NestedType do
    use ZoiDefstruct

    defstruct name: Zoi.string(), tax: DefaultValue.t()
  end

  test "nested type" do
    assert %NestedType{name: "hello", tax: %DefaultValue{tax_rate: 7}} = %NestedType{
             name: "hello",
             tax: %DefaultValue{}
           }

    assert {:ok, %NestedType{name: "hello", tax: %DefaultValue{tax_rate: 7}}} =
             Zoi.parse(NestedType.t(), %NestedType{name: "hello", tax: %DefaultValue{}})
  end

  test "parse map" do
    assert {:ok, %A{name: "hello"}} = Zoi.parse(A.t(), %{name: "hello"})
    assert {:ok, %A{name: "hello"}} = Zoi.parse(A.t(), %{"name" => "hello"})
  end
end
