# Security Policy

## Supported versions

This project tracks the latest stable release of every component. Only the
`main` branch and the most recent tagged release receive security fixes.

| Version            | Supported |
| ------------------ | --------- |
| `main` (latest)    | Yes       |
| Latest release tag | Yes       |
| Older releases     | No        |

## Reporting a vulnerability

**Do not open a public issue for security problems.**

Report privately via a GitHub Security Advisory:
<https://github.com/RegEdits-TSC/Dino-Bot-Website/security/advisories/new>

Please include:

- A description of the issue and its impact
- Steps to reproduce or a proof of concept
- Affected version, commit, or endpoint

## Response targets

| Stage                       | Target              |
| --------------------------- | ------------------- |
| Acknowledge report          | 48 hours            |
| Initial assessment          | 5 business days     |
| Fix for critical severity   | 24-48 hours         |
| Fix for high severity       | 7 days              |
| Fix for medium/low severity | Next release cycle  |

## Patch policy

All dependencies and toolchains are kept on the latest stable / LTS release.
Critical advisories for the security-critical components (Go toolchain,
`go-webauthn`, `pgx`, `golang.org/x/crypto`, `chi`, `templ`, the container base
image) are patched within 24-48 hours. See
[`docs/security/PATCH_POLICY.md`](docs/security/PATCH_POLICY.md).

## Disclosure

We follow coordinated disclosure. We will agree on a disclosure timeline with
the reporter and credit reporters who wish to be named.
