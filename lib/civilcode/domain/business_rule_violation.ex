defmodule CivilCode.BusinessRuleViolation do
  @moduledoc false

  defstruct [:entity, :type]

  defmacro __using__(_) do
    quote do
      def new(params), do: struct(__MODULE__, params)
    end
  end
end
