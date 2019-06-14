defmodule Craftcha.Player do
  alias Craftcha.HttpRequest
  alias Craftcha.HttpResponse
  alias Craftcha.Session

  defstruct hostname: "", name: "", level: 0, score: 0

  def add_player(hostname, name) do
    uuid = Ecto.UUID.generate
    Craftcha.Session.add_server(uuid, hostname, name)
    {:ok, uuid}
  end

  def get_player(uuid) do
    player = Craftcha.Session.get_server(uuid)
    struct(Craftcha.Player, player)
  end

  @doc """
  This function may be called when a player has finished working on a level.
  It will check that there are no regressions in the previous levels,
  and that the new level is working.
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
    Enum.map(0..playerLevel, fn level -> check_level(uuid, level) end)
  end

  @doc """
  Calculates the points for this try.
  The `result_list` must be an Enum of booleans (index is the level result)
  """
  def get_points(results_list) do
    case has_error(results_list) do
      false -> 100
      true -> get_error_points(results_list)
    end
  end

  def has_error(results_list), do: Enum.member?(results_list, false)

  def get_error_points(results_list) do
    last = Enum.at(results_list, -1)
    previous_results = Enum.drop results_list, -1
    get_points_for_old_errors(previous_results) + get_points_for_last_level_error(last)
  end

  def get_points_for_old_errors(previous_results) do
    Enum.count(previous_results, fn x -> x == false end) * -50
  end

  def get_points_for_last_level_error(last_result) do
    case last_result do
      true -> 0
      false -> -10
    end
  end

  @doc """
  Do HTTP request and validate the response
  """
  def check_level(uuid, request, check_function) do
    hostname = get_player(uuid).hostname
    request_with_hostname = %HttpRequest{request | hostname: hostname}
    {result, response} = HttpRequest.do_http_request(request_with_hostname)
    case result do
      :ok ->
        response
        |> HttpRequest.parseResponse
        |> check_function.()
      :error ->
        {false, "Could not connect"}
    end
  end

  def check_level(uuid, level) do
    case level do
      0 -> check_level_0(uuid)
      1 -> check_level_1(uuid)
    end
  end

  @doc """
  The player must return a 200 OK with 'Hello World!' as a response
  """
  def check_level_0(uuid) do
    request = %HttpRequest{verb: :get, route: ""}
    check_level(uuid, request, &validate_level_0/1)
  end

  def validate_level_0(%HttpResponse{status: status, body: body}) do
    status == 200
    && body == 'Hello World!'
  end

  def check_level_1(uuid) do
    request = %HttpRequest{verb: :get, route: ""}
    check_level(uuid, request, &validate_level_1/1)
  end

  def validate_level_1(%HttpResponse{status: status, body: body}) do
    status == 200
    && body == 'Hello World!'
  end

end
