# Build stage
FROM golang:1.24-alpine AS builder

WORKDIR /app

# Install ca-certificates for HTTPS and git for go modules
RUN apk add --no-cache ca-certificates git

# Copy go mod files first for better caching
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags='-w -s -extldflags "-static"' \
    -o /app/api \
    ./cmd/api

# Runtime stage
FROM alpine:3.20

# Install CA certificates for HTTPS
RUN apk add --no-cache ca-certificates

# Copy the binary
COPY --from=builder /app/api /api

# Copy migrations
COPY --from=builder /app/migrations /migrations

# Expose port
EXPOSE 8080

# Run the binary
CMD ["/api"]
