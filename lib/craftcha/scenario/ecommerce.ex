### GAME SPECIFIC ###
defmodule Craftcha.Scenario.Ecommerce do
  @behaviour Craftcha.Scenario

  alias Craftcha.Validation
  alias Craftcha.HttpRequest

  @max_level 1

  def get_max_level() do
    @max_level
  end

  @doc """
  For each level, returns {:ok} if successful, {:error, [errors]} in case of failure
  """
  def get_level_tests(level) do
    case level do
      0 -> get_tests_level_0()
      1 -> get_tests_level_1()
    end
  end

  @doc """
  The player must return a 200 OK with "Hello Bob!" as a response
  """
  def get_tests_level_0 do
    request = %HttpRequest{verb: :get, route: "", params: [{"name", "Bob"}]}
    checks = [
      &Validation.check_status(&1, 200),
      &Validation.check_body(&1, "Hello Bob")
    ]
    test_1 = {request, checks}

    request = %HttpRequest{verb: :get, route: "/noroute"}
    validations = [&Validation.check_status(&1, 404)]
    test_2 = {request, validations}

    [test_1, test_2]
  end

  def get_tests_level_1 do
    request = %HttpRequest{verb: :get, route: "/api/price", params: [{"ref", "123456789432"}]}
    checks = [
      &Validation.check_status(&1, 200),
      &Validation.check_body(&1, "12.95€")
    ]
    test_1 = {request, checks}

    request = %HttpRequest{verb: :get, route: "/api/price", params: [{"ref", "000"}]}
    checks = [
      &Validation.check_status(&1, 400),
    ]
    test_2 = {request, checks}

    request = %HttpRequest{verb: :get, route: "/api/price", params: [{"ref", "542512394625"}]}
    checks = [
      &Validation.check_status(&1, 200),
      &Validation.check_body(&1, "0.15€")
    ]
    test_3 = {request, checks}

    [test_1, test_2, test_3]
  end


  def get_instructions(level) do
    case level do
      0 -> "
# Welcome to e-commerce Crafter's API Challenge

Please start your server on the port you defined when registering (default is 3000).
Your server should:
- Answer 200 OK with the body *Hello Name* when the route _/_ is called with the method GET, the name to add
to the message will be passed in the query parameter _name_
- Answer 404 ERROR when any other route is called

Please click on _Check_ button when you are ready

Every level passed gives 100 points, a wrong anwer on a new level loses 10 points,
and a wrong answer on a previous level (regression) costs 50 pts.
"
      1 -> "
# Get price for one article

Your first task will be to compute the total price of a command (only one article by command)

## Request

```
Method: GET
Route: /api/price
Query params:
  ref: item reference
```

## Response
The response should contain the price of the item as a string (with currency symbol)

## Status

- 200 OK when the reference is found
- 400 when the reference is not found

## Data
|Reference     |Price |
|--------------|------|
|123456789432  |12.95€|
|542512394625  | 0.15€|
|155612348958  |69.90€|
|087123485142  |15.00€|

"
      2 -> ""
      3 -> ""
    end
  end

end
