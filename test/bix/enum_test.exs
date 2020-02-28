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

  test "trival map with carry little endian" do
    a = <<0x80, 0x00, 0x00, 0x00>>
    b = <<0x00, 0x01, 0x00, 0x00>>
    fun = &(Bix.Carry.bsl(&1, 1, &2))
    assert Bix.Enum.map_with_carry(a, fun, [endian: :little, carry_in: 0]) == b
  end

  test "trivial map with carry big endian" do
    a = <<0x00, 0x00, 0x00, 0x80>>
    b = <<0x00, 0x00, 0x01, 0x00>>
    fun = &(Bix.Carry.bsl(&1, 1, &2))
    assert Bix.Enum.map_with_carry(a, fun, [endian: :big, carry_in: 0]) == b
  end

  test "zip with carry little endian" do
    a = <<0xf8, 0x00>>
    b = <<0x08, 0x00>>
    c = <<0x00, 0x01>>
    fun = &Bix.Carry.add/3
    assert Bix.Enum.zip_with_carry(a, b, fun, endian: :little) == c
  end

  test "zip with carry big endian" do
    a = <<0x00, 0xf8>>
    b = <<0x00, 0x08>>
    c = <<0x01, 0x00>>
    fun = &Bix.Carry.add/3
    assert Bix.Enum.zip_with_carry(a, b, fun, endian: :big) == c
  end
end
