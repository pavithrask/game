# Game

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
    * This will created the database `game_dev` and table `users` with 1_000_000 user seed data with `id` and the `points` of the users
    * Initially the `points` is zero for each user
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
    * This will start the a genserver which keeps 2 elements in the state like below:
      * `min_number` - This is a random number between 0 - 100 which will be generated every minute
      * `timestamp` of the last request made to the genserver
    * Genserver also updates the `points` of each user with a random number between 0 - 100 every minute 

Now when visit [`localhost:4000`](http://localhost:4000) from your browser, it will show a response json with maximum two users who have points more than the `min_number`

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
