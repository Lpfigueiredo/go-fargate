# syntax=docker/dockerfile:1

# Build the application from source
FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.20-alpine AS build-stage

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

WORKDIR /app

COPY . .
RUN go mod download

RUN --mount=target=. \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg \
    CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags="-w -s" -o /go-docker

# Run the tests in the container
FROM build-stage AS run-test-stage
RUN go test -v ./...

# Deploy the application binary into a lean image
FROM --platform=${TARGETPLATFORM:-linux/amd64} alpine AS build-release-stage

WORKDIR /

COPY --from=build-stage /go-docker /go-docker

RUN apk --no-cache add curl

EXPOSE 3000

ENTRYPOINT ["/go-docker"]
