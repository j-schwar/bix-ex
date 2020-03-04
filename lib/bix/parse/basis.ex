defmodule Bix.Parse.Basis do
  @typedoc """
  Basis is a set of 8 bitstrings, each representing a single bit of every byte
  in sequence. For example, basis[0] (i.e., the first element in the tuple), 
  holds all of the 0 bits from each byte in some input. basis[1] all of the 1 
  bits etc.

  When constructed from a binary (or string) using `from_bytes`, each bitstring
  in the resultant basis set is encoded using big-endian.

  Each bitstring in the set must be the exact same length.
  """
  @type basis ::
          {bitstring, bitstring, bitstring, bitstring, bitstring, bitstring, bitstring, bitstring}

  defguardp empty_basis(b) when b == {<<>>, <<>>, <<>>, <<>>, <<>>, <<>>, <<>>, <<>>}
          
  @doc """
  Constructs a big-endian basis set from some binary.
  """
  @spec from_bytes(binary) :: basis
  def from_bytes(bytes) do
    import Bitwise
    bit = fn x -> Bix.Enum.map(bytes, &(bsr(&1, x) &&& 0x01)) end

    {
      compress_binary(bit.(0)),
      compress_binary(bit.(1)),
      compress_binary(bit.(2)),
      compress_binary(bit.(3)),
      compress_binary(bit.(4)),
      compress_binary(bit.(5)),
      compress_binary(bit.(6)),
      compress_binary(bit.(7))
    }
  end

  @doc """
  Converts a basis set back into a binary.

  This is the inverse operation of `from_bytes`.
  """
  @spec to_bytes(basis) :: binary
  def to_bytes(basis_set), do: do_to_bytes(basis_set, <<>>)

  defp do_to_bytes(basis_set, acc) when empty_basis(basis_set), do: acc

  defp do_to_bytes({b0, b1, b2, b3, b4, b5, b6, b7}, acc) do
    import Bitwise

    {b0, b0s} = uncons_bit(b0)
    {b1, b1s} = uncons_bit(b1)
    {b2, b2s} = uncons_bit(b2)
    {b3, b3s} = uncons_bit(b3)
    {b4, b4s} = uncons_bit(b4)
    {b5, b5s} = uncons_bit(b5)
    {b6, b6s} = uncons_bit(b6)
    {b7, b7s} = uncons_bit(b7)

    byte = b0 ||| (b1 <<< 1) 
              ||| (b2 <<< 2)
              ||| (b3 <<< 3)
              ||| (b4 <<< 4)
              ||| (b5 <<< 5)
              ||| (b6 <<< 6)
              ||| (b7 <<< 7)

    # Bitstrings are encoded using big-endian meaning we are iterating through
    # the text in reverse. As such, we append the newly formed byte to the front
    # so that the resultant binary is in the correct order.
    acc = <<byte>> <> acc
    do_to_bytes({b0s, b1s, b2s, b3s, b4s, b5s, b6s, b7s}, acc)
  end

  @doc """
  Retrieves the basis bitstring with a given index.
  """
  @spec get_basis(basis, 0..7) :: bitstring
  def get_basis(basis_set, index)

  def get_basis({b, _, _, _, _, _, _, _}, 0), do: b
  def get_basis({_, b, _, _, _, _, _, _}, 1), do: b
  def get_basis({_, _, b, _, _, _, _, _}, 2), do: b
  def get_basis({_, _, _, b, _, _, _, _}, 3), do: b
  def get_basis({_, _, _, _, b, _, _, _}, 4), do: b
  def get_basis({_, _, _, _, _, b, _, _}, 5), do: b
  def get_basis({_, _, _, _, _, _, b, _}, 6), do: b
  def get_basis({_, _, _, _, _, _, _, b}, 7), do: b

  @spec compress_binary(binary, bitstring) :: bitstring
  defp compress_binary(a, acc \\ <<>>)

  defp compress_binary(a, acc) when a != <<>> do
    {x, xs} = Bix.Binary.uncons(a)
    acc = << <<x::size(1)>>, acc::bitstring >>
    compress_binary(xs, acc)
  end

  defp compress_binary(<<>>, acc), do: acc

  @spec uncons_bit(bitstring) :: {0|1, bitstring}
  defp uncons_bit(a) do
    <<x::size(1), xs::bitstring>> = a
    {x, xs}
  end
end
