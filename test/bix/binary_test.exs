defmodule Bix.BinaryTest do
  use ExUnit.Case
  doctest Bix.Binary

  test "first" do
    assert Bix.Binary.first(<<1, 2, 3>>) == 1
  end

  test "last" do
    assert Bix.Binary.last(<<1, 2, 3>>) == 3
  end

  test "rest" do
    assert Bix.Binary.rest(<<1, 2, 3>>) == <<2, 3>>
  end

  test "rest of single binary" do
    assert Bix.Binary.rest(<<1>>) == <<>>
  end

  test "uncons" do
    assert Bix.Binary.uncons(<<1, 2, 3>>) == {1, <<2, 3>>}
  end

  test "uncons of single binary" do
    assert Bix.Binary.uncons(<<1>>) == {1, <<>>}
  end

  test "uncons_r" do
    assert Bix.Binary.uncons_r(<<1, 2, 3>>) == {3, <<1, 2>>}
  end

  test "uncons_r of single binary" do
    assert Bix.Binary.uncons_r(<<1>>) == {1, <<>>}
  end
end
