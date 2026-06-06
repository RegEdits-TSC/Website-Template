# Website Template

A secure-by-default **template repository** for a Go web application. Click
**Use this template** to start a new project on an already-hardened baseline:
the security tooling, CI/CD, and supply-chain controls ship first; application
code is added on top.

## Stack

| Layer            | Choice                                  | Version    |
| ---------------- | --------------------------------------- | ---------- |
| Runtime          | Go (static binary, `CGO_ENABLED=0`)     | 1.26.4     |
| Router           | `go-chi/chi`                            | v5.3.0     |
| Database         | PostgreSQL via `pgx` + `sqlc`           | 18.x       |
| Templating       | `templ` + `htmx`                        | latest     |
| Auth             | `go-webauthn` passkeys + Postgres sessions | latest  |
| Container        | distroless static, non-root             | -          |

The architecture and its security rationale were chosen for the smallest
attack surface, smallest dependency tree, and easiest path to staying on the
latest stable release of every component.

## Security baseline

Every push and pull request runs:

- **CodeQL** SAST (Go + the workflows themselves)
- **govulncheck** reachability-aware vulnerability scanning
- **golangci-lint** with **gosec** and resource/SQL-safety linters
- **gitleaks** secret scanning (full history)
- **dependency-review** blocking vulnerable or disallowed-license deps
- **OpenSSF Scorecard** supply-chain posture scoring

All GitHub Actions are pinned to commit SHAs, run with least-privilege
permissions, and use `step-security/harden-runner`. The release container
pipeline builds a signed (cosign keyless) image with an SBOM and SLSA
provenance attestation.

Dependencies are kept on the latest stable release by **Renovate**.

See [`SECURITY.md`](SECURITY.md) and [`docs/security/`](docs/security/) for the
policy, threat model, patch SLA, and the one-time repository settings to enable.

## Getting started

```sh
pip install pre-commit && pre-commit install   # local guardrails
make audit                                      # full local quality + security gate
```

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for the full workflow and rules.

## License

Released under the [MIT License](LICENSE).
