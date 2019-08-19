### GAME SPECIFIC ###
defmodule Craftcha.Scenario.Logistock do
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
  The player must return a 200 OK with 'Hello Bob!' as a response
  """
  def get_tests_level_0 do
    request = %HttpRequest{verb: :get, route: "", params: [{'name', 'Bob'}]}
    checks = [
      &Validation.check_status(&1, 200),
      &Validation.check_body(&1, 'Hello Bob')
    ]
    first_test = {request, checks}

    request = %HttpRequest{verb: :get, route: '/noroute'}
    validations = [&Validation.check_status(&1, 404)]
    second_test = {request, validations}

    [first_test, second_test]
  end

  def get_tests_level_1 do
    request = %HttpRequest{verb: :get, route: "/api/bill", params: [{'test', 'test'}]}
    checks = [
      &Validation.check_status(&1, 200),
      &Validation.check_body(&1, 'Coucou')
    ]
    first_test = {request, checks}

    [first_test]
  end


  def get_instructions(level) do
    case level do
      0 -> "
# Welcome to LogiStock Crafter's API Challenge

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
      Your first task will be to compute the total price of a command

|Request    |Values                   |
|-----------|-------------------------|
|Route      |/api/bill                |
|Body       |List of items (see below)|

|Response   |Values                   |
|-----------|-------------------------|
|Route      |/api/bill                |
|Body       |List of items (see below)|
"
      2 -> ""
      3 -> ""
    end
  end

end
