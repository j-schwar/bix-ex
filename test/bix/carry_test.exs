defmodule Bix.CarryTest do
  use ExUnit.Case
  doctest Bix.Carry

  test "add zero" do
    assert Bix.Carry.add(0, 0, 0) == {0, 0}
  end

  test "add carry out" do
    assert Bix.Carry.add(128, 128, 0) == {0, 1}
  end

  test "add carry in" do
    assert Bix.Carry.add(128, 127, 1) == {0, 1}
  end

  test "add" do
    assert Bix.Carry.add(200, 100, 1) == {45, 1}
  end

  test "shift left zero" do
    assert Bix.Carry.bsl(0, 0, 0) == {0, 0}
  end

  test "shift left carry out single bit" do
    assert Bix.Carry.bsl(0x40, 2, 0) == {0, 1}
  end

  test "shift left carry out multiple bits" do
    assert Bix.Carry.bsl(0xA0, 4, 0) == {0, 0x0A}
  end

  test "shift left carry in" do
    assert Bix.Carry.bsl(0, 1, 1) == {1, 0}
  end

  test "shift left carry in multiple bits" do
    assert Bix.Carry.bsl(0xAF, 3, 0x5) == {0x7D, 0x5}
  end
end
