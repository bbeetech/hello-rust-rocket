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

FROM rust:latest

# COPY --from=build /app/target/release/<app_service_name> .
# CMD ["./<app_service_name>"]

COPY --from=build /app/target/release/app_service .

# Rocket framework: Add config file
COPY ./Rocket.toml ./Rocket.toml

CMD ["./app_service"]