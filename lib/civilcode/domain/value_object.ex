defmodule CivilCode.ValueObject do
  @moduledoc false

  def string(_) do
    quote do
      use CivilCode.ValueObject.String
    end
  end

  def non_neg_integer(_) do
    quote do
      use CivilCode.ValueObject.NonNegInteger
    end
  end

  def uuid(_) do
    quote do
      use CivilCode.ValueObject.Uuid
    end
  end

  def composite(opts) do
    required = Keyword.get(opts, :required)

    quote do
      use CivilCode.DomainPrimitive.Composite

      def validate(schema), do: validate_required(schema, unquote(required))
    end
  end

  defmacro __using__(opts) do
    type = Keyword.get(opts, :type)

    apply(__MODULE__, type, [opts])
  end
end
