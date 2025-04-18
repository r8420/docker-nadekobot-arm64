# NadekoBot v6 · ARM 64 Docker Image · `docker‑nadekobot‑arm64`

Community‑maintained Docker wrapper that builds **[NadekoBot](https://github.com/nadeko-bot/nadekobot)** for aarch64 / ARM 64 devices (Synology, Raspberry Pi 5, Odroid, …).

> **Why?**  
> The official `ghcr.io/nadeko-bot/nadekobot:v6` image is **x86‑64‑only**.  
> This project builds, packages and publishes an equivalent image for ARM 64.

---

## 🏗 Image contents

| Component                    | Version / Source                                         | Notes           |
|------------------------------|----------------------------------------------------------|-----------------|
| .NET 8 runtime‑deps          | `mcr.microsoft.com/dotnet/runtime-deps:8.0`              | `linux‑arm64`   |
| NadekoBot                    | tag/branch **v6** (build‑arg `NADEKO_VERSION`)           | AGPL‑3          |
| yt‑dlp                       | latest release binary                                    | `yt-dlp_linux_aarch64` |
| ffmpeg · libopus · libsodium | Debian 12 packages                                       | voice / music  |

---

## 🚀 Quick start

Pull the **latest** image:

```bash
docker pull ghcr.io/r8420/docker-nadekobot-arm64:latest
```

Run:

```bash
docker run -d --name nadeko \
  -e bot_token=YOUR_TOKEN \
  -v /opt/nadeko/data:/app/data \
  --restart unless-stopped \
  ghcr.io/r8420/docker-nadekobot-arm64:latest
```

Alternatively, pin to a specific release:

```bash
docker run -d --name nadeko \
  -e bot_token=YOUR_TOKEN \
  -v /opt/nadeko/data:/app/data \
  --restart unless-stopped \
  ghcr.io/r8420/docker-nadekobot-arm64:v6.1.7
```

---

## 🔄 Updating

```bash
docker pull ghcr.io/r8420/docker-nadekobot-arm64:latest
docker stop nadeko && docker rm nadeko
# run the docker run command you used originally
```

The database & config live in `/app/data`, so they survive upgrades.

---

## 🧑‍💻 Build locally

```bash
git clone https://github.com/r8420/docker-nadekobot-arm64.git
cd docker-nadekobot-arm64
# optional: export NADEKO_VERSION=v6.1.7  (build a different tag/commit)
docker build --no-cache -t nadeko-arm64:v6.1.7 .
```

---

## 🪪 License & attribution

* **NadekoBot** is dual licensed under **AGPL v3** and a **Commercial** license.  
  See [`LICENSE.md`](LICENSE.md) and [`LICENSE-AGPLv3.md`](LICENSE-AGPLv3.md) for details.  
  Contact: `br.eaker` on Discord or <nadekodiscordbot@gmail.com>.
* This wrapper simply automates building **NadekoBot** for ARM 64.
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

This repo includes a GitHub Actions workflow that:

1. Builds the image for `linux/arm64`
2. Pushes it to GHCR as:
   - `ghcr.io/r8420/docker-nadekobot-arm64:v${{ steps.vars.outputs.NADEKO_VERSION }}`
   - `ghcr.io/r8420/docker-nadekobot-arm64:latest`

See [`.github/workflows/build.yml`](.github/workflows/build.yml).
