defmodule Craftcha.Player do
  alias Craftcha.HttpRequest
  alias Craftcha.HttpResponse

  defstruct hostname: "", name: "", level: 0

  def add_player(hostname, name) do
    uuid = Ecto.UUID.generate
    Craftcha.Session.add_server(uuid, hostname, name)
    {:ok, uuid}
  end

  def get_player(uuid) do
    player = Craftcha.Session.get_server(uuid)
    struct(Craftcha.Player, player)
  end

  def check(uuid) do
    playerLevel = get_player(uuid).level
    Enum.map(0..playerLevel, fn level -> check_level(uuid, level) end)
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

end
