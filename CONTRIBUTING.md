# Contributing

## Setup

```sh
pip install pre-commit
pre-commit install
```

Go, `golangci-lint`, and `govulncheck` are needed for the full local checks.
The hooks no-op gracefully when a tool is missing, but CI will enforce them.

## Workflow

1. Branch from `main` with a descriptive name (`fix-session-rotation`, not `patch-1`).
2. Make the change. Add or update tests for any behavior change.
3. Run the local checks (see below). They must pass before you push.
4. Open a PR. Fill in the security checklist. A code owner reviews before merge.

## Local checks

```sh
gofmt -l .
go vet ./...
golangci-lint run
go test -race -shuffle=on ./...
govulncheck ./...
```

## Hard rules

- **Dependencies** stay on the latest stable release. Run `go mod tidy` and
  commit the result; CI fails on an untidy `go.mod`.
- **GitHub Actions** are pinned to a full commit SHA with a `# vX.Y.Z` comment.
  Never reference a mutable tag (`@v4`) or branch.
- **Workflow permissions** are least-privilege. Start from `contents: read` and
  grant the minimum each job needs.
- **No secrets in the repo**, ever - not in code, config, tests, or history.
  Use environment variables and the platform secret store.
- **SQL**: parameterized queries only. Never concatenate user input into a
  query. Allow-list any dynamic identifier (sort column, table name).
- **Output**: rely on contextual escaping. Do not use `templ.Raw` or
  trusted-type conversions on user-derived data.
- **AuthZ**: every object access enforces an ownership/permission check. Add an
  IDOR regression test alongside the code.

## Commits

Use [Conventional Commits](https://www.conventionalcommits.org/)
(`feat:`, `fix:`, `chore:`, `docs:`, `test:`, `refactor:`). Sign your commits.
