defmodule CivilCode.Maybe do
  @moduledoc """
  Handles the presences of a value. Based on the F# type.
  See [The Option type](https://fsharpforfunandprofit.com/posts/the-option-type/)
  """
  use Currying

  @type t(value) :: {:some, value} | :none
  @type a :: any
  @type b :: any
  @type c :: any

  @spec none() :: :none
  def none, do: :none

  @spec some(nil | a) :: no_return | t(a)
  def some(nil), do: raise("Maybe.some/1 expects a non-nil value")
  def some(value), do: new(value)

  @spec new(nil | any) :: t(any)
  def new(nil), do: :none
  def new(value), do: {:some, value}

  @spec map(t(a), (... -> b)) :: t(b) | t((... -> b))
  def map(:none, _f), do: none()
  def map({:some, value}, f), do: new(curry(f).(value))

  @spec none?(t(a)) :: boolean
  def none?(:none), do: true
  def none?({:some, _value}), do: false

  @spec some?(t(a)) :: boolean
  def some?({:some, _value}), do: true
  def some?(:none), do: false

  @spec unwrap!({:some, a}) :: a
  def unwrap!({:some, value}), do: value

  @spec flatten(t(t(a))) :: t(a)
  def flatten(:none), do: :none
  def flatten({:some, {:some, value}}), do: flatten({:some, value})
  def flatten({:some, :none}), do: :none
  def flatten({:some, value}), do: {:some, value}

  @spec combine(t(a), t(b)) :: t(c)
  def combine({:some, lhs}, {:some, rhs}) do
    {:some, List.flatten([lhs, rhs])}
  end

  def combine({:some, lhs}, :none) do
    {:some, List.flatten([lhs])}
  end

  def combine(:none, {:some, rhs}) do
    {:some, List.flatten([rhs])}
  end

  def combine(:none, :none) do
    :none
  end
end
