defmodule AstraTest do
  use ExUnit.Case
  doctest Astra

  test "greets the world" do
    assert Astra.hello() == :world
  end
end
