defmodule Craftcha.Player do
  alias Craftcha.HttpRequest
  alias Craftcha.Session
  use PlumberGirl

  defstruct hostname: "",
            name: "",
            level: 0,
            score: 0,
            last_result: nil,
            finished: false

  ### GAME SPECIFIC VALUES

  @level_ok_points 100
  @old_level_error_points -50
  @new_level_error_points -10
  @max_level 2

  def add_player(hostname, name) do
    uuid = Ecto.UUID.generate
    Craftcha.Session.add_server(uuid, hostname, name)
    {:ok, uuid}
  end

  def get_player(uuid) do
    player = Craftcha.Session.get_server(uuid)
    struct(Craftcha.Player, player)
  end

  def list_players() do
    Craftcha.Session.get_all_scores()
    |> Enum.map(fn {k, v} -> Map.put(v, :id, k) end)
  end

  @doc """
  This function may be called when a player has finished working on a level.
  It will check that there are no regressions in the previous levels,
  and that the new level is working.

  Deprecated
  """
  def try_next_level(uuid) do
    results = check(uuid)
    IO.inspect results
    points = get_points(results)
    Session.add_points(uuid, points)
    if has_error(results) do
      :error
    else
      go_next_level(uuid)
      :ok
    end
  end

  def go_next_level(uuid) do
    Session.next_level(uuid)
  end

  def check(uuid) do
    playerLevel = get_player(uuid).level
    hostname = get_player(uuid).hostname
    result = Enum.map(0..playerLevel, fn level -> check_level(hostname, level) end)
    Session.set_last_result(uuid, result)

    points = result
             |> get_result_list
             |> get_points
    Session.add_points(uuid, points)

    has_error = result
                |> get_result_list
                |> has_error
    case has_error do
      true -> nil
      false -> go_next_level(uuid)
    end

    IO.inspect(result, label: "result")
    result
  end

  @doc """
  Calculates the points for this try.
  The `result_list` must be an Enum of :ok/:error (index is the level result)
  """
  def get_points(results_list) do
    case has_error(results_list) do
      false -> @level_ok_points
      true -> get_error_points(results_list)
    end
  end

  @doc """
  ## Examples
  iex> Player.has_error([:ok, :error])
  true
  iex> Player.has_error([:ok])
  false
  iex> Player.has_error([:error])
  true
  """
  def has_error(results_list), do: Enum.member?(results_list, :error)

  def get_result_list(results), do: Enum.map(results, fn {a, _b} -> a  end)

  def get_error_points(results_list) do
    if length(results_list) == 1 do
      0
    else
      last = Enum.at(results_list, -1)
      previous_results = Enum.drop results_list, -1
      get_points_for_old_errors(previous_results) + get_points_for_last_level(last)
    end
  end

  def get_points_for_old_errors(previous_results) do
    Enum.count(previous_results, fn x -> x == :error end) * @old_level_error_points
  end

  def get_points_for_last_level(last_result) do
    case last_result do
      :ok -> 0
      :error -> @new_level_error_points
    end
  end

  @doc """
  Do HTTP request and validate the response
  """
  def check_request(request, check_functions) do
    {result, response} = HttpRequest.do_http_request(request)
    case result do
      :ok ->
        parsedResponse = HttpRequest.parseResponse(response)
        Enum.map(check_functions, fn check -> check.(parsedResponse) end)
      :error ->
        [{:error, "Could not connect"}]
    end
  end

  def has_finished(uuid) do
    get_player(uuid).level == @max_level
  end

  def get_max_level(), do: @max_level

  def perform_test(hostname, {req, checks}) do
    complete_request = %{req | hostname: hostname}
    check_request(complete_request, checks)
  end

  def reduce_tests(result, _acc) do
    case result do
      {:ok, _res} -> {:cont, {:ok, "OK"}}
      {:error, message} -> {:halt, {:error, message}}
    end
  end

  def check_level(hostname, level) do
    get_level_tests(level)
    |> Enum.flat_map(&perform_test(hostname, &1))
    |> Enum.reduce_while({:ok, ""}, &reduce_tests/2)
  end

  ### VALIDATION HELPERS

  def check_status(response, status) do
    if response.status == status do
      {:ok, "Status is " <> Integer.to_string(status)}
    else
      {:error, "Status should be " <> Integer.to_string(status)}
    end
  end

  def check_body(response, value) do
    IO.inspect response
    if(response.body == value) do
      {:ok, "OK"}
    else
      error_message = "Body should be " <> to_string(value) <> ", received: " <> to_string(response.body)
      {:error, error_message}
    end
  end

  ### GAME SPECIFIC ###

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
      &check_status(&1, 200),
      &check_body(&1, 'Hello World!')
    ]
    first_test = {request, checks}

    request = %HttpRequest{verb: :get, route: '/noroute'}
    validations = [&check_status(&1, 404)]
    second_test = {request, validations}

    [first_test, second_test]
  end

  def get_tests_level_1 do
    [check_level_1_ok()]
  end

  def check_level_1_ok do
    request = %HttpRequest{verb: :get, route: '/ok'}
    validations = [&check_body(&1, 'ok')]
    {request, validations}
  end

end
