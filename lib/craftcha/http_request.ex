defmodule Craftcha.HttpRequest do
  alias Craftcha.HttpResponse

  defstruct verb: :get, hostname: "localhost", port: "3000", route: "/", params: [], body: {}

  @doc """
  Do an Http request
  """
  def do_http_request(http_request) do
    IO.inspect(http_request, label: "do http request")
    case http_request.verb do
      :get -> send_get(http_request)
    end
  end

  def send_get(http_request) do
    client = getClient()
    base_url = get_base_url(http_request)
    IO.inspect(base_url, label: "base url")
    url= Tesla.build_url(base_url, http_request.params)
    response = Tesla.get(client, url)
    IO.inspect(response, label: "GET response")
  end

  @doc """
  Parse an http client response
  """
  def parse_response(response) do
    %HttpResponse{status: response.status, body: response.body}
  end

  def getClient() do
    middleware = [
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end

  def get_base_url(http_request) do
    "http://" <> http_request.hostname <> ":" <>  http_request.port <> http_request.route
  end


end
