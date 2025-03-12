# --- СТАДІЯ 1: BUILD ---

FROM golang:alpine3.21 AS builder

RUN apk --no-cache --no-progress add --virtual \
  build-deps \
  build-base \
  git

WORKDIR /app/gogs

COPY go.mod go.sum .

RUN go mod download

COPY . .

RUN go build -buildvcs=false -o gogs

# --- SRAGE 2: PROD ---

FROM alpine:3.21

RUN apk --no-cache add git linux-pam-dev

WORKDIR /app

RUN addgroup -S gogs && adduser -S gogs -G gogs

RUN mkdir -p /app/custom/conf && chown -R gogs:gogs /app/custom

COPY custom/conf/app.ini /app/custom/conf/app.ini

RUN chmod -R 777 /app/custom/conf

COPY --from=builder /app/gogs/gogs /app/

RUN chown -R gogs:gogs /app

EXPOSE 3000 22

USER gogs

CMD ["/app/gogs", "web"]
