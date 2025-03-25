# --- STAGE 1: START ---

FROM golang:alpine3.21 AS base
LABEL org.opencontainers.image.source=https://github.com/Tymchuk25/gogsprod.git

FROM base AS deps
WORKDIR /app
COPY go.mod go.sum ./

RUN go mod download

COPY . .

# --- STAGE 2: LINT ---

FROM deps AS lint
WORKDIR /app
#COPY .golangci.yml .
COPY . .
RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
RUN golangci-lint run --verbose --timeout=5m ./...

# --- STAGE 3: TEST ---

FROM deps AS test
WORKDIR /app
RUN apk --no-cache add openssh-client
RUN go test ./...

# --- STAGE 4: BUILD ---
FROM deps AS builder
RUN apk add --no-cache \ 
    build-base \
    git
WORKDIR /app

RUN go build -buildvcs=false -o gogs

# --- STAGE 5: RUN ---

FROM base AS runner
RUN apk --no-cache add git linux-pam-dev
WORKDIR /app

RUN addgroup -S gogs && adduser -S gogs -G gogs
RUN mkdir -p /app/custom/conf && chown -R gogs:gogs /app/custom
RUN mkdir -p /app/data && chown -R gogs:gogs /app/data
COPY custom/conf/app.ini /app/custom/conf/app.ini
RUN chmod -R 777 /app/custom/conf
COPY --from=builder /app/gogs /app/
RUN chown -R gogs:gogs /app
USER gogs

EXPOSE 3000 22

CMD ["/app/gogs", "web"]

