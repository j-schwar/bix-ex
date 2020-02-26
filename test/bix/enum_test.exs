defmodule Bix.EnumTest do
  use ExUnit.Case
  doctest Bix.Enum

  test "map empty binary" do
    assert Bix.Enum.map(<<>>, &(&1 + 1)) == <<>>
  end

  test "map" do
    expected = <<1, 2, 3, 4>>
    assert Bix.Enum.map(<<0, 1, 2, 3>>, &(&1 + 1)) == expected
  end

  test "zip empty binary" do
    assert Bix.Enum.zip(<<>>, <<>>, &(&1 + &2)) == <<>>
  end

  test "zip" do
    a = <<0, 1, 2, 3>>
    b = <<3, 2, 1, 0>>
    c = <<3, 3, 3, 3>>
    assert Bix.Enum.zip(a, b, &(&1 + &2)) == c
  end

  test "map with carry little endian" do
    a = <<0x80, 0xa0, 0x01, 0x80>>
    b = <<0x01, 0x41, 0x03, 0x00>>
    fun = &(Bix.Carry.bsl(&1, 1, &2))
    assert Bix.Enum.map_with_carry(a, fun, [endian: :little, carry_in: 1]) == b
  end

  test "map with carry big endian" do

  end
end
