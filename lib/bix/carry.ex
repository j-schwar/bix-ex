defmodule Bix.Carry do
  @moduledoc """
  Defines a collection of functions which support explicit bit carries.

  Such functions take carry-in bit from some previous operation and return their
  result (e.g., sum, shift, etc.) along with a carry-out bit which may be passed
  on to some future operation.
  """

  use Bitwise, only_operators: true

  @doc """
  N-bit addition with carry-in and carry-out. Assuming N <= 8.

  ## Examples

      iex> Bix.Carry.add(1, 1, 0)
      {2, 0}

      iex> Bix.Carry.add(1, 2, 1)
      {4, 0}

      iex> Bix.Carry.add(255, 3, 1)
      {3, 1}

  The `bit_width` parameter determines the width of the add. For example a 3-bit
  add can be performed like so:

      iex> Bix.Carry.add(0x07, 0x01, 0, 3)
      {0, 1}

  """
  @spec add(byte, byte, byte, 1..8) :: {byte, byte}
  def add(a, b, carry_in, bit_width \\ 8) do
    sum = a + b + carry_in
    carry_out = sum >>> bit_width
    sum_trunc = Bix.Binary.first(<<sum::size(bit_width)>>)
    {sum_trunc, carry_out}
  end

  @doc """
  Shifts the bits of `x` to the left `s` number of positions truncating the 
  result to a specific `bit_width`.

  Only shifts of less than 8 bits at a time are supported at the moment.

  ## Example

      iex> Bix.Carry.bsl(0xaf, 3, 0x02)
      {0x7a, 0x05}

      iex> Bix.Carry.bsl(0x0f, 3, 0x02, 4)
      {0x0a, 0x07}

  """
  @spec bsl(byte, 0..7, byte, 1..8) :: {byte, byte}
  def bsl(x, s, carry_in, bit_width \\ 8) when s < 8 do
    carry_out = x >>> (bit_width - s)
    result = x <<< s ||| carry_in
    result_trunc = Bix.Binary.first(<<result::size(bit_width)>>)
    {result_trunc, carry_out}
  end
end
