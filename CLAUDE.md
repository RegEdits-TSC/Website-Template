# Project engineering guide

Security-first Go web application. This baseline exists before any feature code.
These rules are load-bearing - follow them on every change.

## Stack (keep on latest stable)

- Go 1.26.4, static binary, `CGO_ENABLED=0`
- Router: `go-chi/chi` v5
- Data: PostgreSQL + `pgx` + `sqlc` (hand-written SQL, generated type-safe Go)
- Views: `templ` (compile-time escaping) + `htmx`
- Auth: `go-webauthn` passkeys, argon2id fallback, opaque server-side sessions
- Deploy: distroless static container, non-root, read-only rootfs

## Non-negotiable rules

1. **Dependencies stay on the latest stable release.** After any dependency
   change, run `go mod tidy` and commit it. CI fails on an untidy `go.mod`.
2. **Pin GitHub Actions to a full commit SHA** with a `# vX.Y.Z` comment. Never
   a mutable tag or branch. Renovate keeps the SHAs current.
3. **Least-privilege workflows.** Default `permissions: contents: read`; grant
   each job only what it needs. Every job uses `harden-runner`.
4. **No secrets in the repo or history.** Config via env vars, validated at
   boot. A missing/invalid secret must fail startup, not a live request.
5. **SQL is always parameterized.** Static queries through `sqlc`; dynamic
   fragments through `pgx` with bound values and allow-listed identifiers.
   Never `fmt.Sprintf` user input into a query.
6. **Output is contextually escaped.** No `templ.Raw` or trusted-type
   conversion on user-derived data. Serve `htmx` under a nonce CSP with the
   `hx-csp` extension; sanitize dynamic fragments before any `innerHTML` swap.
7. **AuthZ on every object access.** Deny-by-default ownership checks; add an
   IDOR regression test with the code.
8. **Tests track behavior.** New behavior gets a test that would have failed
   before. Bug fixes get a regression test. Cover golden path + one edge case.
   Security-critical paths (WebAuthn RP/origin/counter checks, session rotation,
   CSRF, RLS cross-tenant denial) are test-covered, not assumed.

## Local gate

`make audit` runs fmt, vet, golangci-lint (gosec), tests (race), govulncheck,
and tidy. It must pass before pushing.

## When adding the application

Put the entrypoint at `cmd/server/`. The CI language jobs and the container
pipeline activate automatically once Go sources and the `./cmd/server` target
exist - no workflow edits required.
