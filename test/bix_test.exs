defmodule BixTest do
  use ExUnit.Case, async: false
  use ExCheck

  doctest Bix

  ## Bix.band

  test "bitwise and" do
    a = <<0xAA, 0x01, 0xFF, 0x00>>
    b = <<0x42, 0xFE, 0x91, 0xFF>>
    c = <<0x02, 0x00, 0x91, 0x00>>
    assert Bix.band(a, b) == c
  end

  test "bitwise and empty binary" do
    assert Bix.band(<<>>, <<>>) == <<>>
  end

  test "bitwise and single byte" do
    assert Bix.band(<<5>>, <<3>>) == <<1>>
  end

  ## Bix.bor

  test "bitwise or" do
    a = <<0xAA, 0x01, 0xFF, 0x00>>
    b = <<0x42, 0xFE, 0x91, 0xFF>>
    c = <<0xEA, 0xFF, 0xFF, 0xFF>>
    assert Bix.bor(a, b) == c
  end

  test "bitwise or empty binary" do
    assert Bix.bor(<<>>, <<>>) == <<>>
  end

  test "bitwise or single byte" do
    assert Bix.bor(<<5>>, <<3>>) == <<7>>
  end

  ## Bix.bnot

  test "bitwise not" do
    a = <<0xAA, 0x01, 0xFF, 0x00>>
    b = <<0x55, 0xFE, 0x00, 0xFF>>
    assert Bix.bnot(a) == b
  end

  test "bitwise not empty binary" do
    assert Bix.bnot(<<>>) == <<>>
  end

  test "bitwise not single byte" do
    assert Bix.bnot(<<5>>) == <<0xFA>>
  end

  ## Bix.bsl

  test "shift left empty binary" do
    assert Bix.bsl(<<>>, 3) == <<>>
  end

  test "shift left" do
    assert Bix.bsl(<<0x01, 0x80, 0x04>>, 4) == <<0x10, 0x00, 0x48>>
  end

  ## Property Tests

  property :add_little_endian do
    for_all {x, y} in {non_neg_integer(), non_neg_integer()} do
      a = <<x::little-64>>
      b = <<y::little-64>>
      r = x + y
      Bix.add(a, b, endian: :little) == <<r::little-64>>
    end
  end

  property :add_big_endian do
    for_all {x, y} in {non_neg_integer(), non_neg_integer()} do
      a = <<x::big-64>>
      b = <<y::big-64>>
      r = x + y
      Bix.add(a, b, endian: :big) == <<r::big-64>>
    end
  end
end
