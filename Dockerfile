FROM rust:1.64 as builder
WORKDIR /usr/src/cicd
COPY . .
RUN cargo install --path .

FROM debian:buster-slim
RUN apt-get update && apt-get install -y procps net-tools curl && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/cargo/bin/cicd /usr/local/bin/cicd
ENTRYPOINT ["/usr/local/bin/cicd"]