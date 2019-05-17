defmodule CivilCode.ApplicationService do
  @moduledoc """
  * the "write" side
  * responsible for processing business use cases
  * contain functions reflecting commands to operate on an aggregate
  * typically following the pattern of `impure` -&gt; `pure` -&gt; `impure` function calls
  * e.g. `read from the repo` -&gt; `call domain logic` -&gt; `write to the repo`
  * `Service` modules hydrate domain concepts from a repo, call a function\(s\) to perform domain logic and then write the "modified" domain concept to the database.
  * Top level/public `Service` functions should be only a pipeline \(either `|>` or `with`\) providing a high-level overview of the processing steps.
  """

  defmacro __using__(_) do
  end
end