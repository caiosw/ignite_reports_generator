defmodule ReportsGeneratorTest do
  use ExUnit.Case

  describe "build/1" do
    test "build report from file" do
      filename = "report_test.csv"

      response = ReportsGenerator.build(filename)

      expected_response = {
        :ok,
        %{
          "foods" => %{
            "açaí" => 1,
            "churrasco" => 2,
            "esfirra" => 3,
            "hambúrguer" => 2,
            "pizza" => 2
          },
          "users" => %{
            "1" => 48,
            "10" => 36,
            "2" => 45,
            "3" => 31,
            "4" => 42,
            "5" => 49,
            "6" => 18,
            "7" => 27,
            "8" => 25,
            "9" => 24
          }
        }
      }

      assert response == expected_response
    end
  end

  describe "build_from_many/1" do
    test "when given a list of files, build the report" do
      filenames = [
        "report_test.csv",
        "report_test.csv"
      ]

      response = ReportsGenerator.build_from_many(filenames)

      expected_response = {
        :ok,
        %{
          "foods" => %{
            "açaí" => 2,
            "churrasco" => 4,
            "esfirra" => 6,
            "hambúrguer" => 4,
            "pizza" => 4
          },
          "users" => %{
            "1" => 96,
            "10" => 72,
            "2" => 90,
            "3" => 62,
            "4" => 84,
            "5" => 98,
            "6" => 36,
            "7" => 54,
            "8" => 50,
            "9" => 48
          }
        }
      }

      assert response == expected_response
    end

    test "when a file list is not provided, returns an error" do
      filenames = "potato"

      response = ReportsGenerator.build_from_many(filenames)

      expected_response = {:error, "Please provide a list of strings"}

      assert response == expected_response
    end
  end

  describe "fetch_higher_cost/2" do
    test "when the option is 'users', should return the user that spent the most" do
      filename = "report_test.csv"

      response =
        filename
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_cost("users")

      expected_response = {:ok, {"5", 49}}

      assert response == expected_response
    end

    test "when the option is 'foods', should return the food that was ordered the most" do
      filename = "report_test.csv"

      response =
        filename
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_cost("foods")

      expected_response = {:ok, {"esfirra", 3}}

      assert response == expected_response
    end

    test "when an invalid option is given, should return an error" do
      filename = "report_test.csv"

      response =
        filename
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_cost("potato")

      expected_response = {:error, "Invalid option!"}

      assert response == expected_response
    end
  end
end
