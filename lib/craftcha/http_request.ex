defmodule Craftcha.HttpRequest do
  alias Craftcha.HttpResponse

  defstruct verb: :get, hostname: 'localhost', route: '/', params: []

  @doc """
  Do an Http request
  """
  def do_http_request(http_request) do
    IO.inspect(http_request, label: "do http request")
    url = to_charlist(http_request.hostname) ++ to_charlist(http_request.route)
    url_with_params = if length(http_request.params) > 0 do
       Enum.reduce(http_request.params, url ++ '?', fn {key, value}, acc -> acc ++ key ++ '=' ++ value end)
    else
      url
    end
    IO.inspect(url_with_params, label: "url")
    :httpc.request(http_request.verb, {url_with_params, []}, [], [])
  end

  @doc """
  Parse an http client response
  """
  def parseResponse({{_, status, _}, _headers, res}) do
    %HttpResponse{status: status, body: res}
  end

end
