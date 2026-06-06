# syntax=docker/dockerfile:1
#
# Hardened, reproducible build of a single static Go binary on a shell-less,
# non-root distroless base. Activates once ./cmd/server exists.
# Base images are digest-pinned for reproducibility; Renovate keeps the
# digests current (see the dockerfile pinDigests rule in renovate.json).

# ---- build stage ----
FROM golang:1.26.4-alpine@sha256:f23e8b227fb4493eabe03bede4d5a32d04092da71962f1fb79b5f7d1e6c2a17f AS build
ENV CGO_ENABLED=0 \
    GOFLAGS=-trimpath
WORKDIR /src

# Cache modules separately from source for faster rebuilds.
# The go.sum glob tolerates the not-yet-existing checksum file while this is a
# scaffold. Once the first dependency lands, drop the glob (COPY go.mod go.sum ./)
# so a missing go.sum fails the build.
COPY go.mod go.sum* ./
RUN go mod download && go mod verify

COPY . .
# -s -w strips the symbol table; -buildid= makes the build reproducible.
RUN go build -ldflags="-s -w -buildid=" -o /out/server ./cmd/server

# ---- runtime stage ----
# distroless static: no shell, no package manager, no libc - minimal attack
# surface and effectively zero OS-level CVEs. Runs as the built-in nonroot user.
FROM gcr.io/distroless/static-debian12:nonroot@sha256:d093aa3e30dbadd3efe1310db061a14da60299baff8450a17fe0ccc514a16639
COPY --from=build /out/server /server
USER nonroot:nonroot
EXPOSE 8080
ENTRYPOINT ["/server"]
