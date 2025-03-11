FROM rust:slim

WORKDIR /project

COPY incremnet incremnet
COPY redb_wrapper redb_wrapper
COPY tools tools 
COPY Cargo.toml Cargo.lock .

RUN cargo build --release --bin incremnet

CMD cargo run --release --bin incremnet
