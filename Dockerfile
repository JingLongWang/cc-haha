FROM oven/bun:1.3.13

WORKDIR /app

ENV NODE_ENV=production \
    SERVER_HOST=0.0.0.0 \
    SERVER_PORT=3456 \
    CLAUDE_CONFIG_DIR=/data/.claude

COPY package.json bun.lock bunfig.toml preload.ts tsconfig.json ./
RUN bun install --frozen-lockfile --production

COPY adapters/package.json adapters/bun.lock ./adapters/
RUN cd adapters && bun install --frozen-lockfile --production

COPY adapters ./adapters
COPY bin ./bin
COPY runtime ./runtime
COPY src ./src
COPY stubs ./stubs

RUN mkdir -p /data/.claude \
  && chown -R bun:bun /app /data

USER bun

EXPOSE 3456
VOLUME ["/data"]

CMD ["bun", "run", "src/server/index.ts", "--host", "0.0.0.0", "--port", "3456"]
