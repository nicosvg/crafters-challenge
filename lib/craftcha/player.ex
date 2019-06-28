defmodule Craftcha.Player do
  alias Craftcha.HttpRequest
  alias Craftcha.HttpResponse
  alias Craftcha.Session
  use PlumberGirl
  use Ecto.Schema
  import Ecto.Changeset

  #  schema "player" do
  #    field :name
  #    field :hostname
  #  end

  defstruct hostname: "", name: "", level: 0, score: 0, last_result: nil

  @level_ok_points 100
  @old_level_error_points -50
  @new_level_error_points -10

  #  def changeset(player, params \\ %{}) do
  #    cast(player, params, [:hostname, :name])
  #  end

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
    players_map = Craftcha.Session.get_all_scores()
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
  def check_request(request, check_function) do
    {result, response} = HttpRequest.do_http_request(request)
    case result do
      :ok ->
        response
        |> HttpRequest.parseResponse
        |> check_function.()
      :error ->
        {:error, "Could not connect"}
    end
  end

  @doc """
  For each level, returns {:ok} if successful, {:error, [errors]} in case of failure
  """
  def check_level(hostname, level) do
    case level do
      0 -> check_level_0(hostname)
      1 -> check_level_1(hostname)
    end
  end

  @doc """
  The player must return a 200 OK with 'Hello World!' as a response
  """
  def check_level_0(hostname) do
    hostname
    |> tee(check_level_0_ok)
    >>> check_level_0_not_found
  end

  def check_level_0_ok(hostname) do
    request = %HttpRequest{verb: :get, route: "", hostname: hostname}
    check_request(request, &validate_level_0/1)
  end

  def check_level_0_not_found(hostname) do
    request = %HttpRequest{verb: :get, route: '/noroute', hostname: hostname}
    validation = &check_status(&1, 404)
    check_request(request, validation)
  end

  def validate_level_0(%HttpResponse{} = response) do
    response
    |> tee(check_status(200))
    >>> check_body('Hello World!')
  end

  def check_status(response, status) do
    if response.status == status do
      {:ok, "OK"}
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

  def check_level_1(hostname) do
    request = %HttpRequest{verb: :get, route: '/ok', hostname: hostname}
    validation = &check_body(&1, 'ok')
    check_request(request, validation)
  end

end
