### GAME SPECIFIC ###
defmodule Craftcha.Scenario.FizzBuzz do
  @behaviour Craftcha.Scenario

  alias Craftcha.Validation
  alias Craftcha.HttpRequest

  @max_level 2

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
  The player must return a 200 OK with 'Hello World!' as a response
  """
  def get_tests_level_0 do
    request = %HttpRequest{verb: :get, route: ""}
    checks = [
      &Validation.check_status(&1, 200),
      &Validation.check_body(&1, 'Hello World!')
    ]
    first_test = {request, checks}

    request = %HttpRequest{verb: :get, route: '/noroute'}
    validations = [&Validation.check_status(&1, 404)]
    second_test = {request, validations}

    [first_test, second_test]
  end

  def get_tests_level_1 do
    [check_level_1_ok()]
  end

  def check_level_1_ok do
    request = %HttpRequest{verb: :get, route: '/ok'}
    validations = [&Validation.check_body(&1, 'ok')]
    {request, validations}
  end

end
