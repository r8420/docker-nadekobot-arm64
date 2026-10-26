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
FROM --platform=linux/arm64 mcr.microsoft.com/dotnet/sdk:11.0@sha256:3a9175b6c54b2f076817af1360f691c9994447b192faa48a1a1f112a516844c7 AS build
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
FROM --platform=linux/arm64 mcr.microsoft.com/dotnet/runtime-deps:11.0@sha256:7d1d198d20d8f0a6bedb791ca7d56cc54c7d2d03e7efd84e0c038bde8407cbf5
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
