# Patch policy

Everything stays on the latest stable / LTS release. Patching speed is treated
as the primary control - a known vulnerability is only as dangerous as the time
it stays unpatched.

## Cadence

| Source                       | Action                                            |
| ---------------------------- | ------------------------------------------------- |
| Renovate version PRs         | Reviewed/merged weekly (Monday window)            |
| Renovate vulnerability PRs   | Raised immediately, prioritized same day          |
| Dependabot / OSV alerts      | Triaged within 24 hours                           |
| Go toolchain security release| Bumped within 24-48 hours                         |
| GitHub Actions               | SHA-pinned; Renovate digest-updates, auto-merged  |
| Container base image         | Renovate digest-pinned; rebuilt on update         |

## Severity SLA

| Severity | Fix deployed within |
| -------- | ------------------- |
| Critical | 24-48 hours         |
| High     | 7 days              |
| Medium   | Next release cycle  |
| Low      | Next release cycle  |

## Watch list (subscribe to GitHub Security Advisories)

These components are security-critical; advisories often break compatibility
for a reason and must be acted on quickly:

- `golang` (the toolchain itself)
- `github.com/go-webauthn/webauthn`
- `github.com/jackc/pgx`
- `golang.org/x/crypto`
- `github.com/go-chi/chi`
- `github.com/a-h/templ`
- the distroless base image

## Auto-merge boundaries

- Auto-merged after CI: Action digest/patch/minor, container base-image digests.
- Never auto-merged: any major version, and the security-critical libraries on
  the watch list above. Those require human review.
