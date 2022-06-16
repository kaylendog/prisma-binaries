# prisma-binaries-docker [![Build](https://github.com/kaylendog/prisma-binaries/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/kaylendog/prisma-binaries/actions/workflows/build.yml)

Provides [Prisma](https://prisma.io) binaries for `aarch64-unknown-linux-musl` platforms.

This image can be used to develop containers based on `node:alpine` using Prisma.

## Usage

The binaries are made available in the image root. You must copy them into your image and specify the relevant environment variables for Prisma to detect them properly.

```docker
FROM skyefuzz/prisma-binaries as prisma

FROM node:alpine
COPY --from=prisma /query-engine /migration-engine /prisma-engines/
# specify environment variables
ENV PRISMA_QUERY_ENGINE_BINARY=/prisma-engines/query-engine \
	PRISMA_MIGRATION_ENGINE_BINARY=/prisma-engines/migration-engine \
	PRISMA_CLI_QUERY_ENGINE_TYPE=binary \
	PRISMA_CLIENT_ENGINE_TYPE=binary

# ...
```
