defmodule CivilCode.DecimalTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  describe "inspect" do
    test "returns a string representation" do
      decimal = Fixtures.Decimal.new!("0.10")

      inspection = fn -> IO.inspect(decimal) end
      assert capture_io(inspection) == "#Fixtures.Decimal<0.10>\n"
    end
  end
end
