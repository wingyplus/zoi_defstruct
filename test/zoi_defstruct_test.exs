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
end
