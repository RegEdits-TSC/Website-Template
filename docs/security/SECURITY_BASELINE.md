# Security baseline

What this repository ships, and the one-time settings you must enable in the
GitHub UI (these cannot be committed as files).

## In the repo (already configured)

| Control                  | Where                                            |
| ------------------------ | ------------------------------------------------ |
| SAST                     | `.github/workflows/codeql.yml` (Go + actions)    |
| Dependency vuln scan     | `.github/workflows/ci.yml` (govulncheck)         |
| Linting + gosec          | `.golangci.yml`, `.github/workflows/ci.yml`      |
| Secret scanning          | `.github/workflows/secret-scan.yml`, `.gitleaks.toml` |
| PR dependency review     | `.github/workflows/dependency-review.yml`        |
| Supply-chain score       | `.github/workflows/scorecard.yml`                |
| Signed image + SBOM + SLSA | `.github/workflows/container.yml`              |
| Hardened runners         | `harden-runner` in every workflow                |
| SHA-pinned actions       | all workflows                                    |
| Dependency freshness     | `renovate.json`                                  |
| Local guardrails         | `.pre-commit-config.yaml`                        |
| Code ownership           | `.github/CODEOWNERS`                             |

## Enable in GitHub settings (one time)

### Settings -> Code security

- [ ] **Dependency graph** - on
- [ ] **Dependabot alerts** - on (the advisory feed that powers Renovate's
      `osvVulnerabilityAlerts` and the dependency-review workflow)
- [ ] **Dependabot security updates** - **off** (Renovate is the sole PR opener;
      enabling this would raise duplicate fix PRs for the same CVE)
- [ ] **Secret scanning** - on
- [ ] **Secret scanning push protection** - on
- [ ] **Code scanning** - default setup off (CodeQL runs via the workflow)
- [ ] **Private vulnerability reporting** - on

### Settings -> Branches -> Branch protection for `main`

- [ ] Require a pull request before merging
- [ ] Require approvals (>= 1) and **Require review from Code Owners**
- [ ] Require status checks to pass. **Today** (no Go code yet) only the
      always-on checks exist, so require exactly these: `Analyze (actions)`,
      `Dependency Review`, `gitleaks`. The Go-gated checks (`Lint`,
      `Test (race + shuffle)`, `govulncheck`, `go.mod is tidy`, `Analyze (go)`)
      are skipped until the first Go commit lands - add them as required checks
      **after** that commit, or they will block every merge while pending.
- [ ] Require branches to be up to date before merging
- [ ] Require signed commits
- [ ] Require linear history
- [ ] Do not allow bypassing the above
- [ ] Restrict force pushes and deletions

### Install Renovate

Install the Renovate GitHub App on this repository:
<https://github.com/apps/renovate>. It reads `renovate.json` and opens the
dependency dashboard issue.

### Deploys

- [ ] Use **GitHub OIDC federation** for cloud deploy credentials - no
      long-lived PATs or cloud keys in Actions secrets.
- [ ] Scope `GITHUB_TOKEN` and any deploy identity to least privilege.
