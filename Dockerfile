# syntax=docker/dockerfile:1
#
# Hardened, reproducible build of a single static Go binary on a shell-less,
# non-root distroless base. Activates once ./cmd/server exists.
# Base images are digest-pinned for reproducibility; Renovate keeps the
# digests current (see the dockerfile pinDigests rule in renovate.json).

# ---- build stage ----
FROM golang:1.27.0-alpine@sha256:4c9fe60190a2a3350ddc51de80d0224b8a6698d12bdfc999fee45ea9d6c46dbc AS build
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
FROM gcr.io/distroless/static-debian12:nonroot@sha256:afa5c872c891853ca7fcf1f12c3edb23f7eeef36189728842dd51042ff57f7ab
COPY --from=build /out/server /server
USER nonroot:nonroot
EXPOSE 8080
ENTRYPOINT ["/server"]
