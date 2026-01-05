# --- build ---
FROM elixir:1.19-alpine AS builder
ENV MIX_ENV=prod
COPY assets ./assets
COPY config ./config
COPY lib ./lib
COPY templates ./templates
COPY mix.exs .
COPY mix.lock .
RUN mix deps.get \
&& mix release

# ---- app ----
FROM alpine:3
RUN apk add --no-cache --update bash openssl libstdc++ libgcc
WORKDIR /app
COPY --from=builder _build/prod/rel/incremnet .
COPY --from=builder ./assets ./assets
COPY --from=builder ./config ./config
CMD ["/app/bin/incremnet", "start"]
