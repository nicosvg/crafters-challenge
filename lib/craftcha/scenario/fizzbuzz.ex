### GAME SPECIFIC ###
defmodule Craftcha.Scenario.FizzBuzz do
  @behaviour Craftcha.Scenario

  alias Craftcha.Validation
  alias Craftcha.HttpRequest

  @max_level 5

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
      2 -> get_tests_level_2()
      3 -> get_tests_level_3()
      4 -> get_tests_level_4()
      5 -> get_tests_level_5()
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
    first_test = {request, checks}

    request = %HttpRequest{verb: :get, route: "/noroute"}
    validations = [&Validation.check_status(&1, 404)]
    second_test = {request, validations}

    [first_test, second_test]
  end

  def get_tests_level_1 do
    [test_level_1_0(), test_level_1_1(), test_level_1_2(), test_level_1_4()]
  end

  def test_level_1_0 do
    request = %HttpRequest{verb: :get, route: "/fizzbuzz", params: [{"value", "3"}]}
    validations = [&Validation.check_body(&1, "Fizz"), &Validation.check_status(&1, 200)]
    {request, validations}
  end

  def test_level_1_1 do
    request = %HttpRequest{verb: :get, route: "/fizzbuzz", params: [{"value", "2"}]}
    validations = [&Validation.check_body(&1, "2"), &Validation.check_status(&1, 200)]
    {request, validations}
  end

  def test_level_1_2 do
    request = %HttpRequest{verb: :get, route: "/fizzbuzz", params: [{"value", "7"}]}
    validations = [&Validation.check_body(&1, "7")]
    {request, validations}
  end

  def test_level_1_4 do
    request = %HttpRequest{verb: :get, route: "/fizzbuzz", params: [{"value", "12"}]}
    validations = [&Validation.check_body(&1, "Fizz"), &Validation.check_status(&1, 200)]
    {request, validations}
  end

  def get_tests_level_2 do
    [test_level_2_0(), test_level_2_1(), test_level_2_2()]
  end

  def test_level_2_0 do
    request = %HttpRequest{verb: :get, route: "/fizzbuzz", params: [{"value", "5"}]}
    validations = [&Validation.check_body(&1, "Buzz"), &Validation.check_status(&1, 200)]
    {request, validations}
  end

  def test_level_2_1 do
    request = %HttpRequest{verb: :get, route: "/fizzbuzz", params: [{"value", "20"}]}
    validations = [&Validation.check_body(&1, "Buzz"), &Validation.check_status(&1, 200)]
    {request, validations}
  end

  def test_level_2_2 do
    request = %HttpRequest{verb: :get, route: "/fizzbuzz", params: [{"value", "4"}]}
    validations = [&Validation.check_body(&1, "4")]
    {request, validations}
  end

  def get_tests_level_3 do
    [test_level_3_0(), test_level_3_1(), test_level_3_2()]
  end

  def test_level_3_0 do
    request = %HttpRequest{verb: :get, route: "/fizzbuzz", params: [{"value", "15"}]}
    validations = [&Validation.check_body(&1, "FizzBuzz"), &Validation.check_status(&1, 200)]
    {request, validations}
  end

  def test_level_3_1 do
    request = %HttpRequest{verb: :get, route: "/fizzbuzz", params: [{"value", "30"}]}
    validations = [&Validation.check_body(&1, "FizzBuzz"), &Validation.check_status(&1, 200)]
    {request, validations}
  end

  def test_level_3_2 do
    request = %HttpRequest{verb: :get, route: "/fizzbuzz", params: [{"value", "1500"}]}
    validations = [&Validation.check_body(&1, "FizzBuzz")]
    {request, validations}
  end

  @doc """
  """
  def get_tests_level_4 do
    request = %HttpRequest{verb: :get, route: "/fizzbuzz", params: [{"value", "13"}]}
    checks = [&Validation.check_body(&1, "Fizz"), &Validation.check_status(&1, 200)]
    first_test = {request, checks}

    request = %HttpRequest{verb: :get, route: "/fizzbuzz", params: [{"value", "34"}]}
    checks = [&Validation.check_body(&1, "Fizz")]
    second_test = {request, checks}

    request = %HttpRequest{verb: :get, route: "/fizzbuzz", params: [{"value", "35"}]}
    checks = [&Validation.check_body(&1, "FizzBuzz")]
    third_test = {request, checks}

    [first_test, second_test, third_test]
  end

  @doc """
  """
  def get_tests_level_5 do
    request = %HttpRequest{verb: :get, route: "/fizzbuzz", params: [{"value", "56"}]}
    checks = [&Validation.check_body(&1, "Buzz"), &Validation.check_status(&1, 200)]
    first_test = {request, checks}

    request = %HttpRequest{verb: :get, route: "/fizzbuzz", params: [{"value", "51"}]}
    checks = [&Validation.check_body(&1, "FizzBuzz"), &Validation.check_status(&1, 200)]
    second_test = {request, checks}

    [first_test, second_test]
  end

  def get_instructions(level) do
    case level do
      0 -> "
## Welcome to Fizz Buzz Crafter's Challenge

We will implement the game of FizzBuzz step by step

Please start your server on the port you defined when registering.
Your server should:
- Answer 200 OK with the body *Hello {Name}* when the route */* is called with the method GET, the name to add
to the message will be passed in the query parameter _name_
- Answer 404 ERROR when any other route is called
"
      1 -> "
## Fizz

Add an endpoint _/fizzbuzz_

A GET on _/fizzbuzz_ with a query param *value* (integer) should return:
- *'Fizz'* if the value is a multiple of 3
- Else: the value in parameter
"
      2 -> "
## Buzz

A GET on _/fizzbuzz_ with a query param *value* (integer) should now return:
- *'Buzz'* if the value is a multiple of 5

The previous rules still apply
"
      3 -> "
## FizzBuzz

A GET on _/fizzbuzz_ with a query param *value* (integer) should now return:
- *'FizzBuzz'* if the value is both a multiple of 3 and 5

The previous rules still apply
"
      4 -> "
## Fizz, new rules

A number is 'Fizz' if it is divisible by 3 or if it has a 3 in it

The previous rules still apply
"
      5 -> "
## Buzz, new rules

A number is 'Buzz' if it is divisible by 5 or if it has a 5 in it

The previous rules still apply
"
    end
  end

end
