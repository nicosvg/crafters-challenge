### GAME SPECIFIC ###
defmodule Craftcha.Scenario do
  @scenario Application.get_env(:craftcha, :scenario)

  IO.inspect @scenario

  @callback get_max_level() :: integer
  @callback get_instructions(level :: integer) :: String.t

  def get_max_level() do
    @scenario.get_max_level()
  end

  def get_level_tests(level) do
    @scenario.get_level_tests(level)
  end

  def get_instructions(level) do
    @scenario.get_instructions(level)
  end

end
