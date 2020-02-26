defmodule Bix.Binary do
  @moduledoc """
  `Bix.Binary` provides some helper methods when working with binaries.
  """

  @doc """
  Returns the first byte of a binary.

  Raises an argument error if `a` is empty.

  ## Example

      iex> Bix.Binary.first <<1, 2, 3, 4>>
      1

  """
  @spec first(binary) :: byte
  def first(a), do: :binary.first(a)

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
  Returns all but the first byte of a binary. Analogous to the `tl` function.

  Raises an argument error if `a` is empty.

  ## Example

      iex> Bix.Binary.rest <<1, 2, 3, 4>>
      <<2, 3, 4>>

  """
  @spec rest(binary) :: binary
  def rest(a), do: :binary.part(a, 1, byte_size(a) - 1)

  @doc """
  A convenience operation which combines the results of `first` and `rest` into
  a single function returning a tuple.

  Raises an argument error if `a` is empty.

  ## Example

      iex> Bix.Binary.uncons <<1, 2, 3>>
      {1, <<2, 3>>}

  """
  @spec uncons(binary) :: {byte, binary}
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
end
