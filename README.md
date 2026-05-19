# vps-config

Docker Compose configurations for my self-hosted VPS, built around [Traefik](https://traefik.io/) as a reverse proxy and [Tailscale](https://tailscale.com/) as a mesh VPN. Private services are never exposed to the public internet, they route exclusively through Tailscale IPs.

If you want to understand the architecture behind this, I wrote a full breakdown on my [personal website](https://www.bpcosta.com/writings/self-hosting-on-a-vps/)].

---

## Services

- **[Traefik](https://traefik.io/)** — Reverse proxy and SSL manager
- **[Vaultwarden](https://github.com/dani-garcia/vaultwarden)** — Self-hosted Bitwarden-compatible password manager
- **[Syncthing](https://syncthing.net/)** — Decentralized file sync
- **[Termix](https://github.com/lukegus/termix)** — Web-based SSH client
- **[AdGuard Home](https://adguard.com/en/adguard-home/overview.html)** — Network-wide DNS ad blocker

## Structure

```text
vps-config/
├── services/
│   ├── adguard/
│   ├── infra/
│   ├── syncthing/
│   ├── termix/
│   └── vaultwarden/
├── scripts/
│   └── sync-configs.sh
├── .gitignore
└── README.md
```

## Deploying

### Prerequisites

- A Linux server with Docker and Docker Compose installed
- A Tailscale account with your server added as a node
- A Cloudflare account managing your domain (required for the Let's Encrypt DNS challenge)

### Setup

Clone the repo and create the external Docker network:

```bash
git clone https://github.com/bpcosta1/vps-config.git ~/vps-config
docker network create proxy-network
```

### Environment variables

All `.env` files are excluded via `.gitignore`. Before starting any container, create a `.env` file in the respective service directory with the following variables:

- `DOMAIN` — Your base domain (e.g. `example.com`)
- `CF_DNS_API_TOKEN` — Cloudflare API token for Traefik
- `ACME_EMAIL` — Email for Let's Encrypt notifications

### Start

```bash
cd ~/vps-config/services/infra && docker compose up -d
cd ../vaultwarden && docker compose up -d
# and so on for the remaining services
```

## Syncing configs

There's a script in `scripts/` that pulls updated compose files from the live VPS into the repo, ignoring `.env` files, so it's ready to commit cleanly:

```bash
cd ~/vps-config
./scripts/sync-configs.sh
git commit -am "update configs" && git push
```
