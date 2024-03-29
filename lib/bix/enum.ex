defmodule Bix.Enum do
  @moduledoc """
  A collection of functions which enumerate over binaries.
  """

  @doc """
  Transforms a bitstring into another by mapping `fun` over it byte by byte.

  The size of the resultant bitstring is equivalent to the size of the first.

  ## Example

      iex> Bix.Enum.map <<1, 2, 3::size(2)>>, &(&1 + 1)
      <<2, 3, 0::size(2)>>

  """
  @spec map(bitstring, (byte -> byte)) :: bitstring
  def map(a, fun), do: do_map(a, fun, <<>>)

  @spec do_map(bitstring, (byte -> byte), bitstring) :: bitstring
  defp do_map(a, fun, acc) when a != <<>> do
    import Bix.Binary

    bit_length = if bit_size(a) >= 8, do: 8, else: bit_size(a)
    {f, r} = uncons(a)
    x = <<fun.(f)::size(bit_length)>>
    acc = concat(acc, x)
    do_map(r, fun, acc)
  end

  defp do_map(<<>>, _fun, acc), do: acc

  @doc """
  Zips two bitstrings together using `fun`.

  Both bitstrings (`a`, and `b`) must have the same `bit_size`.

  ## Example

      iex> Bix.Enum.zip <<1, 2, 4::size(3)>>, <<2, 2, 3::size(3)>>, &Bitwise.bor/2
      <<3, 2, 7::size(3)>>

  """
  @spec zip(binary, binary, (byte, byte -> byte)) :: binary
  def zip(a, b, fun), do: do_zip(a, b, fun, <<>>)

  @spec do_zip(bitstring, bitstring, (byte, byte -> byte), bitstring) :: bitstring
  defp do_zip(a, b, fun, acc) when bit_size(a) == bit_size(b) and a != <<>> do
    import Bix.Binary

    bit_length = if bit_size(a) >= 8, do: 8, else: bit_size(a)
    {x, a} = uncons(a)
    {y, b} = uncons(b)
    z = <<fun.(x, y)::size(bit_length)>>
    acc = concat(acc, z)
    do_zip(a, b, fun, acc)
  end

  defp do_zip(<<>>, <<>>, _fun, acc), do: acc

  @doc """
  Maps a carrying function over a binary starting at the begining of the binary
  advancing towards the end.
  """
  def map_with_carry(a, fun, opts \\ []) do
    endian = Keyword.get(opts, :endian, :little)
    carry_in = Keyword.get(opts, :carry_in, 0)
    case endian do
      :little -> do_map_with_carry_l(a, fun, <<>>, carry_in)
      :big -> do_map_with_carry_r(a, fun, <<>>, carry_in)
      _ -> raise ArgumentError, message: "endian: must be either :little or :big"
    end
  end

  @spec do_map_with_carry_l(binary, (byte, byte, byte -> {byte, byte}), binary, byte) :: binary
  defp do_map_with_carry_l(a, fun, acc, carry_in) when a != <<>> do
    import Bix.Binary

    bit_length = if bit_size(a) >= 8, do: 8, else: bit_size(a)
    {x, a} = uncons(a)
    {z, carry_out} = fun.(x, carry_in, bit_length)
    acc = concat(acc, <<z::size(bit_length)>>)
    do_map_with_carry_l(a, fun, acc, carry_out)
  end

  defp do_map_with_carry_l(<<>>, _fun, acc, _carry_in), do: acc

  @spec do_map_with_carry_r(binary, (byte, byte, byte -> {byte, byte}), binary, byte) :: binary
  defp do_map_with_carry_r(a, fun, acc, carry_in) when a != <<>> do
    import Bix.Binary

    bit_length = if bit_size(a) >= 8, do: 8, else: bit_size(a)
    {x, a} = uncons_r(a)
    {z, carry_out} = fun.(x, carry_in, bit_length)
    acc = concat(<<z::size(bit_length)>>, acc)
    do_map_with_carry_r(a, fun, acc, carry_out)
  end

  defp do_map_with_carry_r(<<>>, _fun, acc, _carry_in), do: acc

  def zip_with_carry(a, b, fun, opts \\ []) do
    endian = Keyword.get(opts, :endian, :little)
    carry_in = Keyword.get(opts, :carry_in, 0)
    case endian do
      :little -> do_zip_with_carry_l(a, b, fun, <<>>, carry_in)
      :big -> do_zip_with_carry_r(a, b, fun, <<>>, carry_in)
      _ -> raise ArgumentError, message: "endian: must be either :little or :big"
    end
  end

  defp do_zip_with_carry_l(a, b, fun, acc, carry_in) when a != <<>> and b != <<>> do
    import Bix.Binary

    bit_length = if bit_size(a) >= 8, do: 8, else: bit_size(a)
    {x, a} = uncons(a)
    {y, b} = uncons(b)
    {z, carry_out} = fun.(x, y, carry_in, bit_length)
    acc = concat(acc, <<z::size(bit_length)>>)
    do_zip_with_carry_l(a, b, fun, acc, carry_out)
  end

  defp do_zip_with_carry_l(<<>>, <<>>, _fun, acc, _carry_in), do: acc

  defp do_zip_with_carry_r(a, b, fun, acc, carry_in) when a != <<>> and b != <<>> do
    import Bix.Binary

    bit_length = if bit_size(a) >= 8, do: 8, else: bit_size(a)
    {x, a} = uncons_r(a)
    {y, b} = uncons_r(b)
    {z, carry_out} = fun.(x, y, carry_in, bit_length)
    acc = concat(<<z::size(bit_length)>>, acc)
    do_zip_with_carry_r(a, b, fun, acc, carry_out)
  end

  defp do_zip_with_carry_r(<<>>, <<>>, _fun, acc, _carry_in), do: acc
end
