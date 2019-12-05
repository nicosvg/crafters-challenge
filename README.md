# Crafters challenge

This is a coding workshop/challenge, inspired by 
[Extreme startup](https://github.com/rchatley/extreme_startup). 
Teams of players must build a software following the changing requirements of a client, 
and ensure that they consistenly provide a functionning product. 

This repository is meant of the workshop facilitator, as it contains the questions 
and answers for all workshop scenarios.

## The workshop

The facilitator should start the *crafters challenge* program on his/her computer.
Currently, this is only possible within an Elixir dev environment, 
binaries will be provided later on.

Each team of players will have to start a web server, and follow the requirements
to pass each level of the scenarios. 
The first level will ensure that their server is up and running,
and that it is able to receive HTTP requests.

## How to start

### Run the application

Install Elixir: [see official documentation](https://elixir-lang.org/install.html) 

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Select a scenario

Edit the following line in file `config.exs`: replace FizzBuzz by any other scenario.

```elixir
config :craftcha, :scenario, Craftcha.Scenario.FizzBuzz
```

## Credits

Created my free logo at [LogoMakr.com](https://my.logomakr.com/)
