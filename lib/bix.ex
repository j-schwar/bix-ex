defmodule Bix do
  @moduledoc """
  `Bix` defines a set of bitwise operations which operate on binaries.
  """

  @doc """
  Performs a bitwise `or` operation on two binaries.

  ## Example

      iex> Bix.bor <<1, 2>>, <<2, 1>>
      <<3, 3>>

  """
  @spec bor(binary, binary) :: binary
  def bor(a, b), do: zip(a, b, &Bitwise.bor/2)

  @doc """
  Performs a bitwise `and` operation on two binaries.

  ## Example

      iex> Bix.band <<3, 2>>, <<1, 1>>
      <<1, 0>>

  """
  @spec band(binary, binary) :: binary
  def band(a, b), do: zip(a, b, &Bitwise.band/2)

  @doc """
  Performs a bitwise `not` operation on a binary.

  ## Example

      iex> Bix.bnot <<1, 0xfe>>
      <<254, 1>>

  """
  @spec bnot(binary) :: binary
  def bnot(a), do: map(a, &Bitwise.bnot/1)

  @doc """
  Zips two binaries together using `fun`.

  `fun` must be an operation which does not produce carry bits, for example
  bitwise or and bitwise and, but not addition.

  Both binaries, `a` and `b`, must have the same number of bytes as this
  operation is not defined for cases where they do not.
  """
  @spec zip(binary, binary, (byte, byte -> byte)) :: binary
  def zip(a, b, fun), do: do_zip(a, b, fun, <<>>)

  @spec do_zip(binary, binary, (byte, byte -> byte), binary) :: binary
  defp do_zip(a, b, fun, acc) when byte_size(a) == byte_size(b) and a != <<>> do
    import Bix.Binary

    {x, a} = uncons a
    {y, b} = uncons b
    z = fun.(x, y)
    acc = acc <> <<z>>
    do_zip(a, b, fun, acc)
  end

  defp do_zip(<<>>, <<>>, _fun, acc), do: acc

  @doc """
  Maps `fun` over each byte in a binary to produce a new binary.
  """
  @spec map(binary, (byte -> byte)) :: binary
  def map(a, fun), do: do_map(a, fun, <<>>)

  @spec do_map(binary, (byte -> byte), binary) :: binary
  defp do_map(a, fun, acc) when a != <<>> do
    import Bix.Binary

    {f, r} = uncons a
    x = fun.(f)
    acc = acc <> <<x>>
    do_map(r, fun, acc)
  end

  defp do_map(<<>>, _fun, acc), do: acc

  @doc """
  Shifts bits in a **little endian** binary to the left by `n` discarding any
  bits that overflow off the end of the binary.

  Due to implementation details, only shifts of < 8 are supported.

  ## Example

      iex> Bix.bsl <<0xff, 0xff, 0xff, 0>>, 3
      <<248, 255, 255, 7>>

  """
  @spec bsl(binary, 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7) :: binary
  def bsl(a, n) when n < 8, do: do_bsl(a, n, 0, <<>>)

  @spec do_bsl(binary, 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7, byte, binary) :: binary
  defp do_bsl(a, n, cin, acc) when a != <<>> do
    import Bix.Binary

    {f, r} = uncons a
    {x, cout} = Bix.Carry.bsl(f, n, cin)
    acc = acc <> <<x>>
    do_bsl(r, n, cout, acc)
  end

  defp do_bsl(<<>>, _n, _cin, acc), do: acc
end
