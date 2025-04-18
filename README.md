# NadekoBot v6 · ARM 64 Docker Image · `docker‑nadekobot‑arm64`

Community‑maintained Docker wrapper that builds **[NadekoBot](https://github.com/nadeko-bot/nadekobot)** for aarch64 / ARM 64 devices (Synology, Raspberry Pi 5, Odroid, …).

> **Why?**  
> The official `ghcr.io/nadeko-bot/nadekobot:v6` image is **x86‑64‑only**.  
> This project builds, packages and publishes an equivalent image for ARM 64.

---

## 🏗 Image contents

| Component | Version / Source | Notes |
|-----------|------------------|-------|
| .NET 8 runtime‑deps | mcr.microsoft.com/dotnet/runtime-deps:8.0 | `linux‑arm64` |
| NadekoBot | tag/branch **v6** (build‑arg `NADEKO_REF`) | AGPL‑3 |
| yt‑dlp | latest release binary | `yt-dlp_linux_aarch64` |
| ffmpeg · libopus · libsodium | Debian 12 packages | voice / music |

---

## 🚀 Quick start

```bash
docker run -d --name nadeko \
  -e bot_token=YOUR_TOKEN \
  -v /opt/nadeko/data:/app/data \
  --restart unless-stopped \
  ghcr.io/r8420/docker-nadekobot-arm64:v6
```

---

## 🔄 Updating

```bash
docker pull ghcr.io/r8420/docker-nadekobot-arm64:v6
docker stop nadeko && docker rm nadeko
# run the same command you used originally
```

The database & config live in `/app/data`, so they survive upgrades.

---

## 🧑‍💻 Build locally

```bash
git clone https://github.com/r8420/docker-nadekobot-arm64.git
cd docker-nadekobot-arm64
# optional: export NADEKO_REF=v6.1  (build a different tag/commit)
docker build --no-cache -t nadeko-arm64:v6 .
```

---

## 🗜 Docker Compose example

```yaml
services:
  nadeko:
    image: ghcr.io/r8420/docker-nadekobot-arm64:v6
    container_name: nadeko
    restart: unless-stopped
    environment:
      TZ: Europe/Amsterdam
      bot_token: "YOUR_TOKEN"
    volumes:
      - /opt/nadeko/data:/app/data
```

---

## 🪪 License & attribution

* **NadekoBot** is licensed under **GNU AGPL v3**.  
  This wrapper simply automates building it for ARM 64.
* See [`LICENSE`](LICENSE) for the full AGPL text.  
* Upstream source: <https://github.com/nadeko-bot/nadekobot>  
* Changes in this repo:  
  * ARM‑64 build stage (`--platform=linux/arm64`)  
  * Added voice libs (`libopus0`, `libsodium23`)  
  * Bundled static `yt-dlp_linux_aarch64` binary  
  * Runtime symlinks under `/app/data_init/lib`  

---

## 🤝 Contributing

PRs welcome! Keep the wrapper minimal—package bumps and fixes go in the Dockerfile or GH Actions workflow.

---

## 📦 Publishing (maintainer notes)

This repo includes a GitHub Actions workflow that

1. Builds the image for `linux/arm64`  
2. Pushes it to GHCR as `ghcr.io/r8420/docker-nadekobot-arm64:v6`

See [`.github/workflows/build.yml`](.github/workflows/build.yml).
