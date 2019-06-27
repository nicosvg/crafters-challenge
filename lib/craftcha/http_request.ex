defmodule Craftcha.HttpRequest do
  alias Craftcha.HttpResponse

  defstruct verb: :get, hostname: 'localhost', route: '/'

  @doc """
  Do an Http request
  """
  def do_http_request(http_request) do
    IO.inspect(http_request, label: "do http request")
    url = to_charlist(http_request.hostname) ++ to_charlist(http_request.route)
    :httpc.request(http_request.verb, {url, []}, [], [])
  end

  @doc """
  Parse an http client response
  """
  def parseResponse({{_, status, _}, _headers, res}) do
    %HttpResponse{status: status, body: res}
  end

end
