defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  @options [
    "foods",
    "users"
  ]

  def build(filename) do
    result = build_from_one(filename)

    {:ok, result}
  end

  defp build_from_one(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  def build_from_many(filenames) when not is_list(filenames) do
    {:error, "Please provide a list of strings"}
  end

  # it executes in parallel, it's more than 3 times faster
  def build_from_many(filenames) do
    result =
      filenames
      |> Task.async_stream(&build_from_one/1)
      |> Enum.reduce(report_acc(), fn {:ok, result}, report -> sum_reports(report, result) end)

    {:ok, result}
  end

  defp sum_reports(
         %{"foods" => foods1, "users" => users1},
         %{"foods" => foods2, "users" => users2}
       ) do
    foods = merge_maps(foods1, foods2)
    users = merge_maps(users1, users2)

    build_report(foods, users)
  end

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 -> value1 + value2 end)
  end

  # when is as Elixir's Guard
  def fetch_higher_cost({:ok, report}, option) when option in @options do
    {:ok, Enum.max_by(report[option], fn {_key, value} -> value end)}
  end

  # if option not in @options, match with bellow function
  def fetch_higher_cost({_, _report}, _option), do: {:error, "Invalid option!"}

  defp sum_values([id, food_name, price], %{"foods" => foods, "users" => users}) do
    users = Map.put(users, id, nil_to_zero(users[id]) + price)
    foods = Map.put(foods, food_name, nil_to_zero(foods[food_name]) + 1)

    # report
    # |> Map.put("users", users)
    # |> Map.put("foods", foods)

    build_report(foods, users)
  end

  defp nil_to_zero(value) do
    # this function allows a dynamic list with new foods without the need to update the list
    # not updating it would break the function
    case value do
      nil -> 0
      _ -> value
    end
  end

  defp report_acc do
    build_report(%{}, %{})
  end

  defp build_report(foods, users), do: %{"foods" => foods, "users" => users}
end
