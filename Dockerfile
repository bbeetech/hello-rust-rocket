FROM rust:latest as build

RUN USER=root cargo new --bin app
WORKDIR /app

COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml
RUN cargo build --release

RUN rm src/*.rs
COPY ./src ./src

# Add Rocket framework config file
COPY ./Rocket.toml ./Rocket.toml

# RUN rm ./target/release/deps/<app_service_name>*  |note: replace - to _
RUN rm ./target/release/deps/app_service*

RUN cargo build --release

FROM rust:slim

# COPY --from=build /app/target/release/<app_service_name> .
# CMD ["./<app_service_name>"]

COPY --from=build /app/target/release/app_service .
CMD ["./app_service"]