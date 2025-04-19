# NadekoBot v6 · ARM 64 Docker Image · `docker‑nadekobot‑arm64`

Community‑maintained Docker wrapper for building and publishing **[NadekoBot](https://github.com/nadeko-bot/nadekobot)** on aarch64/ARM 64 devices (Raspberry Pi, Synology, etc).

> **Why?**  
> The official `ghcr.io/nadeko-bot/nadekobot:v6` image is x86_64-only.  
> This project builds an equivalent ARM 64 image.

---

## 🏗 Image contents

| Component                    | Version / Source                               | Notes                  |
| ---------------------------- | ---------------------------------------------- | ---------------------- |
| .NET 8 runtime-deps          | `mcr.microsoft.com/dotnet/runtime-deps:8.0`    | linux‑arm64            |
| NadekoBot                    | GitHub release tag (build‑arg `NADEKO_VERSION`) | AGPL‑3                 |
| yt-dlp                       | latest GitHub release binary                   | `yt-dlp_linux_aarch64` |
| ffmpeg · libopus · libsodium | Debian 12 packages                             | voice & audio libs     |

---

## 🚀 Quick start

**Pull the latest image**:

```bash
docker pull ghcr.io/r8420/docker-nadekobot-arm64:latest
```

**Pull the major‑version tag**:

```bash
docker pull ghcr.io/r8420/docker-nadekobot-arm64:v6
```

**Run with `latest`**:

```bash
docker run -d --name nadeko \
  -e bot_token=YOUR_TOKEN \
  -v /opt/nadeko/data:/app/data \
  --restart unless-stopped \
  ghcr.io/r8420/docker-nadekobot-arm64:latest
```

**Run with `v6`**:

```bash
docker run -d --name nadeko \
  -e bot_token=YOUR_TOKEN \
  -v /opt/nadeko/data:/app/data \
  --restart unless-stopped \
  ghcr.io/r8420/docker-nadekobot-arm64:v6
```

**Run a specific release** (e.g., `v6.1.7`):

```bash
docker run -d --name nadeko \
  -e bot_token=YOUR_TOKEN \
  -v /opt/nadeko/data:/app/data \
  --restart unless-stopped \
  ghcr.io/r8420/docker-nadekobot-arm64:v6.1.7
```

---

## 🔄 Updating

```bash
docker pull ghcr.io/r8420/docker-nadekobot-arm64:latest
docker stop nadeko && docker rm nadeko
# re-run your docker run command
```

The database & config in `/app/data` persist across updates.

---

## 🧑‍💻 Build locally

```bash
git clone https://github.com/r8420/docker-nadekobot-arm64.git
cd docker-nadekobot-arm64
# optional: export NADEKO_VERSION=v6.1.7
docker build --no-cache -t nadeko-arm64:v6.1.7 .
```

---

## 🪪 License & attribution

**NadekoBot** is dual‑licensed under **AGPL v3** and a **Commercial** license.  
This wrapper merely automates the ARM 64 build.

- See [`LICENSE.md`](LICENSE.md) and [`LICENSE-AGPLv3.md`](LICENSE-AGPLv3.md) for license details.  
- Contact: `br.eaker` on Discord or <nadekodiscordbot@gmail.com>.  
- Upstream source: <https://github.com/nadeko-bot/nadekobot>  
- Changes in this repo:  
  - ARM‑64 build stage (`--platform=linux/arm64`)  
  - Added libs: `libopus0`, `libsodium23`  
  - Bundled static `yt-dlp_linux_aarch64`  
  - Runtime symlinks under `/app/data_init/lib`

---

## 🤝 Contributing

PRs are welcome! Keep changes focused on packaging or CI improvements.

---

## 📦 Publishing (maintainer notes)

Our GitHub Actions workflow:

1. Builds for `linux/arm64`.  
2. Pushes tags:  
   - `ghcr.io/r8420/docker-nadekobot-arm64:v${{ steps.vars.outputs.NADEKO_VERSION }}`  
   - `ghcr.io/r8420/docker-nadekobot-arm64:v6`  
   - `ghcr.io/r8420/docker-nadekobot-arm64:latest`  

See [`.github/workflows/build.yml`](.github/workflows/build.yml).

