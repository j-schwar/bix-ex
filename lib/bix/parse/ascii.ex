defmodule Bix.Parse.Ascii do

  import Bitwise
  alias Bix.Parse.Basis

  @doc """
  Produces a bitstring where each 1 bit represents the location of a given char
  in some basis bits.

  ## Example

      iex> basis = Bix.Parse.Basis.from_bytes "hello world"
      iex> Bix.Parse.Ascii.char(basis, ?o)
      <<0x12, 0::size(3)>>

  """
  @spec char(Basis.basis, byte) :: bitstring
  def char(basis_set, c) do
    s = fn n ->
      if ((c >>> n) &&& 0x01) == 1 do
        Basis.get_basis(basis_set, n)
      else
        Bix.bnot(Basis.get_basis(basis_set, n))
      end
    end

    Bix.band_map [s.(0), s.(1), s.(2), s.(3), s.(4), s.(5), s.(6), s.(7)]
  end
end
