# node-do-app

A simple Node.js / NestJS web application deployed on a DigitalOcean Droplet, fronted by Nginx, and managed end-to-end by the UDAP platform.

## Architecture

- **Runtime**: Node.js 20 + NestJS (TypeScript)
- **Process manager**: PM2 (auto-restart, systemd integration)
- **Reverse proxy**: Nginx (port 80 → app port 3000)
- **Cloud**: DigitalOcean — `s-1vcpu-1gb` Droplet in `nyc1`
- **IaC**: Terraform (Droplet + Firewall)
- **Config management**: Ansible

```
User → Nginx :80 → NestJS App :3000
```

## Endpoints

| Path | Description |
|------|-------------|
| `/` | Landing page |
| `/health` | Health check (JSON) |
| `/api/info` | Application info (JSON) |

## Local Development

```bash
# Install dependencies
npm install

# Start in development mode (hot reload)
npm run start:dev

# Build for production
npm run build

# Start production build
npm start
```

## CI/CD Pipeline

Deploys automatically on push to `main` via GitHub Actions:

| Stage | Description |
|-------|-------------|
| `lint` | ESLint TypeScript checks |
| `test` | Jest unit tests |
| `provision` | Terraform — Droplet + Firewall |
| `configure` | Ansible — Node.js, PM2, Nginx setup |
| `verify` | HTTP health check with retry |

## Configuration

| Variable | Description | Secret |
|----------|-------------|--------|
| `PORT` | App listen port (default: `3000`) | No |
| `DO_TOKEN` | DigitalOcean API token | Yes |
| `SSH_PUBLIC_KEY` | SSH public key for Droplet access | Yes |
| `SSH_PRIVATE_KEY` | SSH private key for CI/Ansible | Yes |
| `TF_STATE_BUCKET` | Terraform state bucket | Yes (platform) |
| `PROJECT_NAME` | Project identifier | Yes (platform) |

## Operations

```bash
# Check app status on server
ssh root@<droplet-ip> pm2 status

# View app logs
ssh root@<droplet-ip> pm2 logs node-do-app

# Restart the app
ssh root@<droplet-ip> pm2 restart node-do-app

# Check Nginx status
ssh root@<droplet-ip> systemctl status nginx
```

The public URL is available after the first deploy at `http://<droplet-ip>` (set after first deploy).

## Destroy

To tear down all infrastructure, trigger the **Destroy** workflow from the GitHub Actions tab.
