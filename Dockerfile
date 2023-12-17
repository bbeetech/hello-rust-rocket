FROM rust:latest as build

RUN USER=root cargo new --bin app
WORKDIR /app

COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml
RUN cargo build --release

RUN rm src/*.rs
COPY ./src ./src

# RUN rm ./target/release/deps/<app_service_name>*  |note: replace - to _
RUN rm ./target/release/deps/app_service*

RUN cargo build --release

FROM debian:buster-slim
RUN apt-get update & apt-get install -y extra-runtime-dependencies & rm -rf /var/lib/apt/lists/*

# COPY --from=build /app/target/release/<app_service_name> .  |note: replace - to _
# CMD ["./<app_name>"] |note: replace - to _

COPY --from=build /app/target/release/app_service .
CMD ["./app_service"]