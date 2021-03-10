# ReportsGenerator

This is an Elixir project from Rocketseat's Ignite course (Chapter 1, module 2).

The project's goal is to create a report from:
- a 300k lines csv with the following columns: user id, food ordered and order price
- the same file fragmented in 3 CSVs

With this we could see the diference between executing it in a single thread and in multiple threads.

The performance can be meassured executing the following lines:
- iex -S mix // start the interactive elixir
- :timer.tc(fn -> ReportsGenerator.build("report_complete.csv") end) // execute it in a single thread, the first value in the tuple is how many microseconds it takes to run
- :timer.tc(fn -> ReportsGenerator.build_from_many(["report_1.csv", "report_2.csv", "report_3.csv"]) end) // same, but multi thread
