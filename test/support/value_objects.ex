defmodule Fixtures do
  defmodule Decimal do
    use CivilCode.ValueObject, type: :decimal
  end

  defmodule NaiveMoney do
    use CivilCode.ValueObject, type: :naive_money
  end
end
