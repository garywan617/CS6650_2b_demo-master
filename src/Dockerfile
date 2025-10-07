# FROM golang:1.19 AS build
# WORKDIR /go/src
# COPY go ./go
# COPY main.go .
# COPY go.sum .
# COPY go.mod .

# ENV CGO_ENABLED=0

# RUN go build -o openapi .

# FROM scratch AS runtime
# ENV GIN_MODE=release
# COPY --from=build /go/src/openapi ./
# EXPOSE 8080/tcp
# ENTRYPOINT ["./openapi"]

# Build stage
FROM golang:1.25 AS builder

WORKDIR /app

# 複製 go.mod 和 go.sum 先下載依賴
COPY go.mod go.sum ./
RUN go mod tidy

# 複製程式碼
COPY . .

# 編譯靜態 binary
ENV CGO_ENABLED=0
RUN go build -o openapi main.go

# Runtime stage
FROM alpine:latest
WORKDIR /root/

# 設定 Gin release mode
ENV GIN_MODE=release

# 複製 binary
COPY --from=builder /app/openapi .

# 開放 port
EXPOSE 8080

# 執行 server
ENTRYPOINT ["./openapi"]
