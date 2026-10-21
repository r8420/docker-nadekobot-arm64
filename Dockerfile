# syntax=docker/dockerfile:1

#################################################################
# NadekoBot v6 – ARM 64 Docker wrapper                          #
# This image:                                                   #
#   • clones upstream (AGPL‑3) at build‑time                    #
#   • publishes a self‑contained linux‑arm64 build              #
#   • bundles ffmpeg, libsodium, libopus, latest yt‑dlp         #
#   • drops symlinks so Nadeko’s voice layer finds the libs     #
#################################################################

################
# BUILD  STAGE #
################
FROM --platform=linux/arm64 mcr.microsoft.com/dotnet/sdk:11.0@sha256:e2438fd800a09d2d761aefe4edd30675c8f1db8958e4423c0844cc9a0240e60f AS build
# renovate: datasource=github-releases depName=nadeko-bot/nadekobot versioning=semver
ARG NADEKO_VERSION=6.1.24                # tag/branch/commit to build
WORKDIR /src

# 1. clone only the requested ref
RUN git clone --depth 1 --branch ${NADEKO_VERSION} \
      https://github.com/nadeko-bot/nadekobot.git /src

# 2. restore & publish self‑contained
RUN dotnet restore NadekoBot.sln -r linux-arm64
WORKDIR /src/src/NadekoBot
RUN dotnet publish -c Release \
      -o /app \
      --self-contained \
      -r linux-arm64 \
      --no-restore \
    && mv /app/data /app/data_init          # preserve seed files

##################
# RUNTIME  STAGE #
##################
FROM --platform=linux/arm64 mcr.microsoft.com/dotnet/runtime-deps:11.0@sha256:f264a0c541ca18cf22eeefa335b00a95281c82f541ca0061f6ef6a7e7aa6e41a
WORKDIR /app

# 3. runtime libraries
RUN apt-get update && apt-get install -y \
      ffmpeg \
      libsodium23 \
      libopus0 \
      curl \
      dos2unix \
    && rm -rf /var/lib/apt/lists/*

# 4. latest yt‑dlp static binary (ARM 64)
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux_aarch64 \
      -o /usr/local/bin/yt-dlp \
    && chmod +x /usr/local/bin/yt-dlp

# 5. copy bot + entrypoint
COPY --from=build /app ./
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN dos2unix /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

# 6. expose libs where Nadeko expects them
RUN mkdir -p /app/data_init/lib && \
    ln -sf /usr/lib/aarch64-linux-gnu/libopus.so.0    /app/data_init/lib/opus.so && \
    ln -sf /usr/lib/aarch64-linux-gnu/libopus.so.0    /app/data_init/lib/opus && \
    ln -sf /usr/lib/aarch64-linux-gnu/libsodium.so.23 /app/data_init/lib/libsodium.so

VOLUME ["/app/data"]

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["./NadekoBot"]
