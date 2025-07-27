FROM rust:latest AS builder
WORKDIR /project
COPY incremnet incremnet
COPY redb_wrapper redb_wrapper
COPY tools tools
COPY Cargo.toml Cargo.lock ./
RUN cargo build --release --bin incremnet

FROM debian:latest
WORKDIR /project
COPY --from=builder /project/target/release/incremnet /project/incremnet
CMD ["/project/incremnet"]
