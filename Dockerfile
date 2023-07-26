# syntax=docker/dockerfile:1

# Build the application from source
FROM golang:1.20-alpine AS build-stage

WORKDIR /app

COPY . .
RUN go mod download

ARG TARGETOS
ARG TARGETARCH

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags "-s -w" -o /go-docker

# Run the tests in the container
FROM build-stage AS run-test-stage
RUN go test -v ./...

# Deploy the application binary into a lean image
FROM alpine AS build-release-stage

WORKDIR /

COPY --from=build-stage /go-docker /go-docker

RUN apk --no-cache add curl

EXPOSE 3000

ENTRYPOINT ["/go-docker"]
