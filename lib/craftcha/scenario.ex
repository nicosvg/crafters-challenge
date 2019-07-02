### GAME SPECIFIC ###
defmodule Craftcha.Scenario do
  @scenario Application.get_env(:craftcha, :scenario)

  IO.inspect @scenario

  @callback get_max_level() :: :number

  def get_max_level() do
    @scenario.get_max_level()
  end

  def get_level_tests(level) do
    @scenario.get_level_tests(level)
  end

end
