defmodule Bix.Carry do
  @moduledoc """
  Defines a collection of functions which support explicit bit carries.

  Such functions take carry-in bit from some previous operation and return their
  result (e.g., sum, shift, etc.) along with a carry-out bit which may be passed
  on to some future operation.
  """

  use Bitwise, only_operators: true

  @doc """
  Guard for integers which can be stored in a single byte.
  """
  defguard is_byte(x) when is_integer(x) and x >= 0 and x < 256

  @doc """
  An integer which is either 0 or 1.
  """
  defguard is_bit(x) when is_integer(x) and (x == 0 or x == 1)

  defguardp are_bytes(x, y) when is_byte(x) and is_byte(y)
  defguardp are_bytes(x, y, z) when is_byte(x) and is_byte(y) and is_byte(z)

  @doc """
  Byte addition with carry-in and carry-out.

  ## Examples

      iex> Bix.Carry.add(1, 1, 0)
      {2, 0}

      iex> Bix.Carry.add(1, 2, 1)
      {4, 0}

      iex> Bix.Carry.add(255, 3, 1)
      {3, 1}

  """
  @spec add(byte, byte, integer) :: {byte, integer}
  def add(a, b, carry_in) when are_bytes(a, b) and is_bit(carry_in) do
    carry_gen = a &&& b
    carry_prop = a ||| b
    sum = :binary.first <<a + b + carry_in :: 8>>
    carry_out = carry_gen ||| (carry_prop &&& ~~~sum)
    carry_out = carry_out >>> 7
    {sum, carry_out}
  end

  @doc """
  Shifts the bits of `x` to the left `s` number of positions.

  Only shifts of less than 8 bits at a time are supported at the moment.

  ## Example

      iex> Bix.Carry.bsl(0xaf, 3, 0x02)
      {0x7a, 0x05}

  """
  @spec bsl(byte, 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7, byte) :: {byte, byte}
  def bsl(x, s, carry_in) when are_bytes(x, s, carry_in) and s < 8 do
    carry_out = x >>> (8 - s)
    result = truncate_byte(x <<< s) ||| carry_in
    {result, carry_out}
  end

  @spec truncate_byte(integer) :: byte
  defp truncate_byte(x), do: :binary.first <<x :: 8>>
end
