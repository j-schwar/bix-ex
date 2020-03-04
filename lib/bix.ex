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
  def bor(a, b), do: Bix.Enum.zip(a, b, &Bitwise.bor/2)

  @doc """
  Performs a bitwise `and` operation on two binaries.

  ## Example

      iex> Bix.band <<3, 2>>, <<1, 1>>
      <<1, 0>>

  """
  @spec band(binary, binary) :: binary
  def band(a, b), do: Bix.Enum.zip(a, b, &Bitwise.band/2)

  @doc """
  Reduces a list of bitstrings into a single one using `band`.
  """
  @spec band_map([bitstring]) :: bitstring
  def band_map([x | []]), do: x
  def band_map([x | xs]), do: band(x, band_map(xs))

  @doc """
  Performs a bitwise `not` operation on a binary.

  ## Example

      iex> Bix.bnot <<1, 0xfe>>
      <<254, 1>>

  """
  @spec bnot(binary) :: binary
  def bnot(a), do: Bix.Enum.map(a, &Bitwise.bnot/1)

  @doc """
  Shifts bits in a **little endian** binary to the left by `n` discarding any
  bits that overflow off the end of the binary.

  Due to implementation details, only shifts of < 8 are supported.

  ## Example

      iex> Bix.bsl <<0xff, 0xff, 0xff, 0>>, 3
      <<248, 255, 255, 7>>

  """
  @spec bsl(binary, 0..7) :: binary
  def bsl(a, n, opts \\ []) when n < 8 do
    Bix.Enum.map_with_carry(a, &(Bix.Carry.bsl(&1, n, &2, &3)), opts)
  end

  def add(a, b, opts \\ []) do
    Bix.Enum.zip_with_carry(a, b, &Bix.Carry.add/4, opts)
  end
end
