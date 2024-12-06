# Use official golang image as builder
FROM golang:1.23.3-alpine AS builder

# Set working directory
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o fabric

# Use scratch as final base image
FROM alpine:latest

# Add user
RUN addgroup --gid 1000 user && adduser -D -u 1000 user -G user

# Copy the binary from builder
COPY --from=builder /app/fabric /fabric

USER user

# Expose port 8080
EXPOSE 8080

# Run the binary with debug output
ENTRYPOINT ["/fabric"]
CMD ["-h"] 
