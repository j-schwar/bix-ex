defmodule Bix.Binary do
  @moduledoc """
  `Bix.Binary` provides some helper methods when working with bitstrings.
  """

  # TODO: Rename module as these now work with bitstrings

  @doc """
  Returns the first byte of a bitstring.

  If the bitstring is smaller than a byte, then the string is zero-extended and
  the value is returned as an unsigned integer.

  Raises an argument exception if passed an empty bitstring.

  ## Examples

      iex> Bix.Binary.first <<1, 2, 3>>
      1

      iex> Bix.Binary.first <<0xff, 0x01::size(1)>>
      255

      iex> Bix.Binary.first <<0x05::size(3)>>
      5

  """
  @spec first(bitstring) :: byte
  def first(a) when bit_size(a) >= 8 do
    <<x, _::bitstring>> = a
    x
  end

  def first(a) when bit_size(a) < 8 and a != <<>> do
    padding = 8 - bit_size(a)
    <<x>> = <<0::size(padding), a::bitstring>>
    x
  end

  def first(<<>>), do: raise ArgumentError, message: "empty bitstring"

  @doc """
  Returns the last byte of a binary.

  Rasises an argument error if `a` is empty.

  ## Example

      iex> Bix.Binary.last <<1, 2, 3, 4>>
      4

  """
  @spec last(binary) :: byte
  def last(a), do: :binary.last(a)

  @doc """
  Returns all but the first byte of a bitstring. Analogous to the `tl` function.

  If the bitstring is smaller than a byte, returns an empty bitstring.

  Raises an argument error if passed an empty bitstring.

  ## Example

      iex> Bix.Binary.rest <<1, 2, 3, 4>>
      <<2, 3, 4>>

      iex> Bix.Binary.rest <<1, 5, 9::size(4)>>
      <<5, 9::size(4)>>

      iex> Bix.Binary.rest <<100::size(7)>>
      <<>>
  """
  @spec rest(bitstring) :: bitstring
  def rest(a) when bit_size(a) >= 8 do
    <<_, xs::bitstring>> = a
    xs
  end

  def rest(a) when bit_size(a) < 8 and a != <<>>, do: <<>>

  def rest(<<>>), do: raise ArgumentError, message: "empty bitstring"

  @doc """
  A convenience operation which combines the results of `first` and `rest` into
  a single function returning a tuple.

  Raises an argument error if `a` is empty.

  ## Example

      iex> Bix.Binary.uncons <<1, 2, 3>>
      {1, <<2, 3>>}

  """
  @spec uncons(bitstring) :: {byte, bitstring}
  def uncons(a) do
    f = first(a)
    r = rest(a)
    {f, r}
  end

  @doc """
  Pops the last element of a binary and returns both it and the rest of the
  binary as a tuple.

  Raises an argument error if `a` is empty.

  ## Example

      iex> Bix.Binary.uncons_r <<1, 2, 3>>
      {3, <<1, 2>>}

  """
  @spec uncons_r(binary) :: {byte, binary}
  def uncons_r(a) do
    x = :binary.part(a, 0, byte_size(a) - 1)
    l = last(a)
    {l, x}
  end

  @doc """
  Concatonates two bitstrings together.

  ## Examples

      iex> Bix.Binary.concat <<1, 2>>, <<3::size(2)>>
      <<1, 2, 3::size(2)>>

      iex> Bix.Binary.concat <<3::size(3)>>, <<1, 2>>
      <<96, 32, 2::size(3)>>

  """
  @spec concat(bitstring, bitstring) :: bitstring
  def concat(a, b) when is_binary(a) and is_bitstring(b) do
    <<a::binary, b::bitstring>>
  end

  def concat(a, b) when is_bitstring(a) and is_binary(b) do
    <<a::bitstring, b::binary>>
  end

  def concat(a, b) when is_bitstring(a) and is_bitstring(b) do
    <<a::bitstring, b::bitstring>>
  end
end
