## Summary

<!-- What does this change do and why? -->

## Security checklist

- [ ] No secrets, tokens, or credentials added to code, config, or history
- [ ] User-supplied input is validated at the boundary; SQL uses parameterized queries (no string concatenation into pgx)
- [ ] Output is contextually escaped; no `templ.Raw` / trusted-type conversion on user-derived data
- [ ] AuthZ ownership checks added for any new object access (no IDOR)
- [ ] New dependencies are on the latest stable release and reviewed (`go mod tidy` is clean)
- [ ] New GitHub Actions are pinned to a full commit SHA with a version comment
- [ ] Workflow permissions remain least-privilege

## Testing

- [ ] `golangci-lint run` passes
- [ ] `go test -race ./...` passes
- [ ] `govulncheck ./...` is clean

## Notes

<!-- Anything reviewers should pay special attention to. -->
