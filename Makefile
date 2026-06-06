# renovate: datasource=go depName=golang.org/x/vuln
GOVULNCHECK_VERSION := v1.3.0
# renovate: datasource=github-releases depName=golangci/golangci-lint
GOLANGCI_LINT_VERSION := v2.12.2

.DEFAULT_GOAL := help

.PHONY: help
help: ## List available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

.PHONY: fmt
fmt: ## Format Go code
	gofmt -l -w .

.PHONY: vet
vet: ## Run go vet
	go vet ./...

.PHONY: lint
lint: ## Run golangci-lint (gosec included)
	golangci-lint run

.PHONY: test
test: ## Run tests with race detector
	go test -race -shuffle=on -covermode=atomic ./...

.PHONY: vuln
vuln: ## Scan for known vulnerabilities
	go run golang.org/x/vuln/cmd/govulncheck@$(GOVULNCHECK_VERSION) ./...

.PHONY: tidy
tidy: ## Tidy and verify go.mod
	go mod tidy
	go mod verify

.PHONY: audit
audit: fmt vet lint test vuln tidy ## Run the full local quality + security gate

.PHONY: hooks
hooks: ## Install pre-commit hooks
	pre-commit install
