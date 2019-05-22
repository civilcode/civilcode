defmodule CivilCode.ValueObject.String do
  defmacro __using__(_) do
    quote do
      use CivilCode.DomainPrimitive

      typedstruct enforce: true do
        field(:value, String.t())
      end

      @behaviour Elixir.Ecto.Type

      @impl true
      def type, do: :string

      @impl true
      def cast(val)

      def cast(%__MODULE__{} = struct), do: {:ok, struct}

      def cast(value) when is_binary(value) do
        value
        |> new()
        |> to_ecto_result
      end

      def cast(_), do: :error

      defp to_ecto_result({:ok, value}), do: {:ok, value}
      defp to_ecto_result({:error, _}), do: :error

      @impl true
      def load(value) when is_binary(value), do: new(value)

      @impl true
      def dump(%__MODULE__{} = struct), do: {:ok, struct.value}
      def dump(_), do: :error
    end
  end
end