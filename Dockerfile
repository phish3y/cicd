FROM rust:1.64 as builder
WORKDIR /usr/src/cicd
COPY . .
RUN cargo install --path .

FROM debian:buster-slim
RUN apt-get update && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/src/cicd/response.json /usr/local/bin/response.json
COPY --from=builder /usr/local/cargo/bin/cicd /usr/local/bin/cicd
CMD ["cicd"]