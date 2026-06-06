# Deploy-security checklist

Assert these before any production deploy. Wire them into a boot-time check so a
misconfiguration fails startup, not a live request (the Go analogue of Django's
`manage.py check --deploy`).

## Transport

- [ ] TLS 1.3; HTTP redirects to HTTPS
- [ ] HSTS with `includeSubDomains` and `preload`
- [ ] `sslmode=verify-full` to PostgreSQL with a pinned CA

## HTTP server hardening

- [ ] `ReadHeaderTimeout`, `ReadTimeout`, `WriteTimeout`, `IdleTimeout` set
- [ ] `MaxHeaderBytes` and a request body-size limit set
- [ ] `Server` header stripped; verbose error pages off in production
- [ ] Host / allowed-host allow-list enforced

## Sessions and CSRF

- [ ] Cookies `Secure`, `HttpOnly`, `SameSite=Lax` (or stricter)
- [ ] Session ID rotates on login and on privilege change
- [ ] Idle + absolute session timeouts enforced
- [ ] Per-request CSRF token on state-changing requests

## Content Security Policy

- [ ] Nonce-based CSP present; `htmx` served under it with `hx-csp`
- [ ] No `unsafe-inline` / `unsafe-eval`

## Auth

- [ ] WebAuthn RP ID, origin, and UV flags pinned to production values
- [ ] Signature counter persisted and verified
- [ ] Identity keyed on the immutable user handle, not a mutable name
- [ ] Recovery path rate-limited and step-up protected

## Data + abuse

- [ ] App connects as a non-owner, non-superuser DB role
- [ ] Row-Level Security enabled on tenant tables (verified by tests)
- [ ] `statement_timeout` set on every connection
- [ ] Edge WAF / shared-store rate limiter in front of login + WebAuthn
- [ ] Per-endpoint concurrency caps on expensive paths

## Secrets + config

- [ ] All secrets injected at runtime from a secret manager (never baked into
      the image or committed)
- [ ] Boot-time validation rejects missing/invalid DB DSN, signing keys, OIDC
      secret, WebAuthn config

## Container

- [ ] Runs as non-root, read-only rootfs, dropped capabilities
- [ ] Image is cosign-signed; SBOM and SLSA provenance verified at deploy
