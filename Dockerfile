# DXD Audit Kit - Reproducible Environment
# Pinned to Sui CLI 1.64.2

# Stage 1: Builder (Rust 1.77+)
FROM rust:1.77-bookworm AS builder
RUN apt-get update && apt-get install -y \
    libssl-dev \
    pkg-config \
    git \
    cmake \
    clang \
    libsqlite3-dev

# Clone specific version
RUN git clone https://github.com/MystenLabs/sui.git --depth 1 --branch mainnet-v1.64.2 /sui
WORKDIR /sui

# Build Sui CLI and Move Prover
# Note: Building from source ensures 'sui move prove' is supported
RUN cargo build --release --bin sui
RUN cargo build --release --manifest-path external-crates/move/Cargo.toml -p move-prover

# Stage 2: Final Image
FROM ubuntu:22.04

# Install Runtime Dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    dotnet-sdk-8.0 \
    libssl3 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Z3 (Solver for Move Prover)
RUN wget https://github.com/Z3Prover/z3/releases/download/z3-4.12.2/z3-4.12.2-x64-glibc-2.31.zip -O /tmp/z3.zip \
    && apt-get update && apt-get install -y unzip \
    && unzip /tmp/z3.zip -d /tmp/z3-extract \
    && mv /tmp/z3-extract/z3-4.12.2-x64-glibc-2.31/bin/z3 /usr/local/bin/z3 \
    && chmod +x /usr/local/bin/z3 \
    && rm -rf /tmp/z3.zip /tmp/z3-extract

# Install Boogie (Formal Verification Engine)
RUN dotnet tool install --global Boogie
ENV PATH="/root/.dotnet/tools:${PATH}"

# Copy binaries from builder
COPY --from=builder /sui/target/release/sui /usr/local/bin/
COPY --from=builder /sui/target/release/move-prover /usr/local/bin/

# Set Move Prover environment variables
ENV Z3_EXE=/usr/local/bin/z3
ENV DOTNET_ROOT=/usr/bin/dotnet
ENV PATH="/usr/bin/dotnet:${PATH}"

# Set working directory
WORKDIR /repo

# Install Python dependencies for vuln-db parser
COPY vuln-db/requirements.txt* /tmp/
RUN if [ -f /tmp/requirements.txt ]; then pip3 install -r /tmp/requirements.txt; else pip3 install PyYAML; fi

# Default entrypoint
CMD ["/bin/bash"]
