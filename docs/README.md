# codeforge - Detailed Documentation

## SSH Keys

Mount your public key to `/etc/ssh-keys/authorized_keys`:

```bash
-v ~/.ssh/id_ed25519.pub:/etc/ssh-keys/authorized_keys:ro
```

SSH is hardened:
- Public key authentication only
- Password and keyboard-interactive authentication disabled
- Root login disabled
- Only `coder` user allowed

## Claude Code Authentication

Pass your OAuth token as an environment variable:

```bash
-e CLAUDE_CODE_OAUTH_TOKEN="your-token"
```

The token is written to `/home/coder/.zshenv` with `600` permissions so it's available in SSH sessions.

## User Setup

- **Username:** `coder` (UID 1000)
- **Shell:** zsh with oh-my-zsh
- **Sudo:** passwordless via wheel group
- **Home:** `/home/coder`

## Persistent Volumes

Mount volumes to persist data across container restarts:

```bash
-v ssh-host-keys:/etc/ssh
-v coder-home:/home/coder
```

When a volume is mounted empty, the entrypoint automatically restores default files:

- `/etc/ssh`: Restores hardened `sshd_config` and generates host keys
- `/home/coder`: Restores `.ssh/` directory, oh-my-zsh, and `.zshrc`

Existing data on subsequent restarts is preserved.

## Building Locally

```bash
docker build -t codeforge .
```

Override the Claude Code version at build time:

```bash
docker build --build-arg CLAUDE_CODE_VERSION=2.1.38 -t codeforge .
```

## Architecture

Multi-arch images are published for `linux/amd64` and `linux/arm64`. The correct Claude Code musl binary is selected automatically at build time via `TARGETARCH`.

## CI/CD

Pushes to `main` trigger: lint, multi-arch build, image scan (Trivy), image validation, and semantic release.

Tags trigger: build and scan.

PRs trigger: lint, multi-arch build, scan, and validation.
