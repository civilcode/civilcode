defmodule CivilCode.DomainEvent do
  @moduledoc """

  References:

  * https://enterprisecraftsmanship.com/2017/10/03/domain-events-simple-and-reliable-solution/
  """

  defmacro __using__(_) do
    quote do
      use TypedStruct
    end
  end
end
