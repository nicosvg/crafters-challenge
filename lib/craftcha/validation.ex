# VALIDATION HELPERS
defmodule Craftcha.Validation do

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
end
