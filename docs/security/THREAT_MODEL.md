# Threat model

Living document. Update it whenever a new trust boundary, data type, or external
dependency is introduced. It is intentionally tailored to the chosen stack.

## Assets

- User credentials and sessions (passkeys, session records)
- User-owned data in PostgreSQL
- Secrets (DB DSN, signing keys, OIDC client secret)
- Build + release integrity (the published container image)

## Trust boundaries

1. Internet -> edge (CDN/WAF) -> application
2. Application -> PostgreSQL
3. CI/CD -> registry / deploy target
4. Third-party dependencies -> application

## Primary threats and the controls that address them

| Threat                          | Control                                                        |
| ------------------------------- | ------------------------------------------------------------- |
| SQL injection                   | `sqlc` static queries; `pgx` bound params; allow-listed identifiers; gosec lint |
| XSS                             | `templ` contextual escaping; nonce CSP + `hx-csp`; lint-ban on `templ.Raw`; Go patch cadence for escaper CVEs |
| Broken object-level authz (IDOR)| Deny-by-default ownership checks; RLS as non-owner role; IDOR regression tests |
| Auth bypass / phishing          | WebAuthn RP/origin/UV pinning; signature-counter check; session rotation; hardened recovery path |
| Memory-safety exploits          | Go (memory-safe), `CGO_ENABLED=0` (no C surface)              |
| Supply-chain compromise         | SHA-pinned actions; digest-pinned base images; harden-runner egress auditing (detective today; promote the release pipeline to `block`); Renovate; SBOM + cosign + SLSA provenance; govulncheck; Scorecard |
| Secret leakage                  | gitleaks (CI + pre-commit); push protection; boot-time config validation; `.gitignore` |
| Application-layer DoS           | Edge WAF + shared-store rate limiter; `net/http` timeouts; body-size caps; `statement_timeout`; bounded argon2id behind a limiter |
| Request smuggling / slowloris   | `net/http` `ReadHeaderTimeout`, `ReadTimeout`, `MaxHeaderBytes` |
| Container breakout / pivot      | distroless static, non-root, read-only rootfs, dropped caps  |

## Known residual risks (track and revisit)

- `templ` shares `html/template`'s escaper; escaper-bypass CVEs require staying
  on current Go patches.
- `htmx` `hx-*` attribute injection is **not** covered by a `script-src` CSP -
  requires `hx-csp` + server-side fragment sanitization.
- Auth correctness is hand-rolled - it lives or dies on its test coverage.
- The weakest enrolled auth method (argon2id password / email recovery) is the
  real security floor; harden and step-up the recovery path.
- `govulncheck` only catches catalogued vulnerabilities, not 0-days in
  dependency parsing/attestation logic.
