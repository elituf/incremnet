FROM rust

WORKDIR /project

COPY incremnet incremnet
COPY redb_wrapper redb_wrapper
COPY tools tools 
COPY Cargo.toml Cargo.lock .

RUN cargo build --release

CMD cargo run --release --bin incremnet
