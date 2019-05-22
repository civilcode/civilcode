defmodule CivilCode.Entity do
  @moduledoc """
  > These redesigned methods have a CQS query contract and act as Factories (11); that is, each
    creates a new Aggregate instance and returns a reference to it." - [IDDD]

  ## Life cycle or operational states

  Determining the current state is done via a predicate:

  ```elixir

  # good

  Order.completed?(order)

  # bad

  order.state == "completed"
  ```

  - pure entities (zero side effects, i.e. no indirect inputs, e.g. env, time)
  - domain actions on entities
  """

  defmodule Metadata do
    @moduledoc false

    @type t :: %__MODULE__{}

    defstruct events: [], changes: [], assigns: %{}
  end

  @type t :: %{optional(atom) => any, __struct__: atom, __entity__: Metadata.t()}

  defmacro __using__(_) do
    quote do
      import CivilCode.Entity, only: [entity_schema: 1]
    end
  end

  defmacro entity_schema(do: block) do
    quote do
      use TypedStruct

      typedstruct do
        unquote(block)
        field(:__entity__, Metadata.t())
      end
    end
  end

  def new(module, attrs \\ []) do
    struct!(module, attrs ++ [__entity__: struct!(Metadata)])
  end

  @doc """
  Provides a space to place any kinda of data onto the entity. For example, the Repository uses
  it to track the original record used to build an Entity.
  """
  @spec put_assigns(t, atom, any) :: t
  def put_assigns(entity, key, value) do
    new_assigns = Map.put(entity.__entity__.assigns, key, value)
    updated_metadata = struct!(entity.__entity__, assigns: new_assigns)
    struct!(entity, __entity__: updated_metadata)
  end

  @spec get_assigns(t, atom) :: any
  def get_assigns(entity, key) do
    entity.__entity__.assigns[key]
  end

  # REPOSITORY RELATED FUNCTIONS

  @doc """
  Builds an entity from another struct. This is used in a Repository to build an entity
  from a database record.
  """
  @spec build(module, {:ok, struct}) :: t
  def build(module, {:ok, state}), do: build(module, state)

  @spec build(module, struct) :: t
  def build(module, state) do
    fields = state |> Map.from_struct() |> Enum.into([])
    struct(module, fields ++ [__entity__: struct!(Metadata)])
  end

  @doc """
  Get the fields from an entity and returns them as a map. This is commonly used to build a
  changeset in a Repository.

  Example:

    Entity.get_fields(order, [:id, :email, :product_id, :quantity])
  """
  @spec get_fields(t, list(atom)) :: map
  def get_fields(entity, fields) do
    entity
    |> Map.from_struct()
    |> Map.take(fields)
  end

  @doc """
  Puts the changes for an entity. This allows tracking of changes which can later be used
  in the Repository.
  """
  @spec put_changes(struct, Keyword.t()) :: struct
  def put_changes(struct, changes) do
    struct!(struct, changes ++ [__entity__: struct!(struct.__entity__, changes: changes)])
  end

  # EVENT RELATED FUNCTIONS

  @doc """
  Updates the state of the entity based on event returned by the function. If the function
  returns an error result the entity will not be updated. The event will be tracked so it maybe
  published later.
  """
  def update(entity, func) do
    case func.(entity) do
      {:error, violation} -> {:error, violation}
      {:ok, event} -> do_update(entity, event)
      event -> do_update(entity, event)
    end
  end

  defp do_update(entity, event) do
    updated_state = apply(entity.__struct__, :apply, [entity, event])

    updated_entity =
      struct!(updated_state, __entity__: struct!(updated_state.__entity__, events: [event]))

    {:ok, updated_entity}
  end
end
