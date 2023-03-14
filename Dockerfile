FROM hexpm/elixir:1.14.0-erlang-25.0-alpine-3.17.0

WORKDIR /app

RUN apk update && apk add --no-cache \
    build-base \
    git \
    inotify-tools \
    openssh-client


RUN mix local.hex --force && \
    mix local.rebar --force

COPY . .

RUN mkdir /root/.ssh
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN --mount=type=ssh HEX_HTTP_TIMEOUT=120 mix do deps.get, deps.compile --warnings-as-errors

EXPOSE 4000

CMD [ "mix", "phx.server" ]