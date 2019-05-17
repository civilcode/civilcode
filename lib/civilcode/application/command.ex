defmodule CivilCode.Command do
  @moduledoc """
  > controlling task management for applications [IDDD]

  Based on the text from Vernon, a Command is considered an application concern. We acknowleged
  that others have different opinions:

  > Commands belong to the core domain (just like domain events). They play an important role in the
    CQRS architecture – they explicitly represent what the clients can do with the application. Just
    like events represent what the outcome of those actions could be.

 [Are CQRS commands part of the domain model?](https://enterprisecraftsmanship.com/2019/01/31/cqrs-commands-part-domain-model/)
  """

  defmacro __using__(_args) do
    quote do
      alias CivilCode.Result

      @type t :: %__MODULE__{}
    end
  end
end
