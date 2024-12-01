FROM hexpm/elixir:1.17.3-erlang-27.1.2-alpine-3.20.3

# Install hex and rebar
RUN mix local.hex --force
RUN mix local.rebar --force

RUN mkdir /app

WORKDIR /app
