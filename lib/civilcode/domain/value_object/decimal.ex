defmodule CivilCode.ValueObject.Decimal do
  @moduledoc """
  A value object based on a decimal.
  """

  defmacro __using__(_opts) do
    quote do
      use CivilCode.ValueObject.Base

      alias CivilCode.Result

      typedstruct enforce: true do
        field(:value, Decimal.t())
      end

      defimpl String.Chars do
        def to_string(value_object) do
          unquote(__CALLER__.module).to_string(value_object)
        end
      end

      defimpl Jason.Encoder do
        def encode(value_object, _opts) do
          Jason.encode!(value_object.value)
        end
      end

      def new(value) when is_binary(value) or is_integer(value) do
        case Ecto.Type.cast(:decimal, value) do
          {:ok, casted_value} -> new(casted_value)
          :error -> Result.error("is invalid")
        end
      end

      def new(%Decimal{} = value) do
        __MODULE__
        |> struct!(value: value)
        |> Result.ok()
      end

      def new(_value) do
        Result.error("is invalid")
      end

      def to_string(value_object) do
        Decimal.to_string(value_object.value)
      end

      defoverridable new: 1, to_string: 1

      @spec to_decimal(t) :: Decimal.t()
      def to_decimal(value_object), do: value_object.value

      use Elixir.Ecto.Type

      @impl true
      def type, do: :decimal

      @impl true
      def cast(%__MODULE__{} = struct), do: Result.ok(struct)

      def cast(value) do
        value
        |> new()
        |> to_ecto_result
      end

      defp to_ecto_result(result) do
        case result do
          {:ok, value} -> Result.ok(value)
          {:error, msg} -> Result.error(message: msg)
        end
      end

      @impl true
      def load(value), do: new(value)

      @impl true
      def dump(%__MODULE__{} = struct), do: Ecto.Type.dump(:decimal, struct.value)
      def dump(_), do: :error
    end
  end
end
