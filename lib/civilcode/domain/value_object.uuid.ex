defmodule CivilCode.ValueObject.Uuid do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use CivilCode.DomainPrimitive
      struct = __MODULE__

      typedstruct enforce: true do
        field(:value, String.t())
      end

      @spec new(String.t()) :: {:ok, t} | {:error, :must_be_uuid}
      def new(value) when is_nil(value), do: {:error, :must_be_uuid}

      def new(value) do
        {:ok, struct(__MODULE__, value: value)}
      end

      defmodule Ecto.Type do
        @moduledoc false

        @behaviour Elixir.Ecto.Type

        @struct struct

        @impl true
        def type, do: :uuid

        @impl true
        def cast(val)

        def cast(%@struct{} = e), do: {:ok, e}

        def cast(value) when is_binary(value) do
          @struct.new(value)
        end

        def cast(_), do: :error

        @impl true
        def load(value) when is_binary(value) do
          {:ok, uuid} = Elixir.Ecto.UUID.load(value)
          @struct.new(uuid)
        end

        @impl true
        def dump(%@struct{} = e), do: Elixir.Ecto.UUID.dump(e.value)
        def dump(_), do: :error
      end
    end
  end
end
