defmodule Craftcha.HttpRequest do
  alias Craftcha.HttpResponse

  defstruct verb: :get, hostname: 'localhost', route: '/'

  @doc """
  Do an Http request
  """
  def do_http_request(http_request) do
    IO.inspect http_request
    :httpc.request(http_request.verb, {http_request.hostname ++ http_request.route, []}, [], [])
  end

  @doc """
  Parse an http client response
  """
  def parseResponse({{_, status, _}, _headers, res}) do
    %HttpResponse{status: status, body: res}
  end

end
