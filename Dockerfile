FROM rust:alpine as builder
LABEL org.opencontainers.image.authors="Kaylen Dart <actuallyori@gmail.com>"

ARG PRISMA_VERSION=3.15.1

# install OS dependencies
RUN apk add curl build-base lld perl git openssl-dev protoc --no-cache

# download and unzip prisma
WORKDIR /build
RUN curl -OJL https://github.com/prisma/prisma-engines/archive/refs/tags/${PRISMA_VERSION}.zip \
	&& unzip prisma-engines-${PRISMA_VERSION}.zip \
	&& mv prisma-engines-${PRISMA_VERSION} prisma-engines

# cd and build
WORKDIR /build/prisma-engines
RUN RUSTFLAGS="-C target-feature=-crt-static -C link-arg=-fuse-ld=lld" cargo build --release

# create blank FS image and copy libs
FROM scratch
LABEL org.opencontainers.image.authors="Kaylen Dart <actuallyori@gmail.com>"
# copy libraries to /
COPY --from=builder \ 
	/build/prisma-engines/query-engine \ 
	/build/prisma-engines/migration-engine \
	/build/prisma-engines/introspection-engine \ 
	/build/prisma-engines/prisma-fmt /
