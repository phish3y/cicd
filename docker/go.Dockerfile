FROM golang:1.23.0-bookworm as builder

WORKDIR /usr/src/cicd
COPY . .
RUN go mod download

RUN go build -o /bin/cicd cmd/main.go

FROM debian:stable-slim

COPY --from=builder /bin/cicd /usr/local/bin/cicd

CMD [ "cicd" ]