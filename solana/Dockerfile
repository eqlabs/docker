# --- Builder ---
FROM rust:1.57 as builder

RUN apt-get update && apt-get install -y \
  libclang-dev \
  libssl-dev \
  libudev-dev \
  wget \
  zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

RUN rustup component add rustfmt

WORKDIR /usr/src

ARG SOLANA_VERSION

RUN wget -q -O solana.tar.gz \
  https://github.com/solana-labs/solana/archive/refs/tags/v${SOLANA_VERSION}.tar.gz && \
  tar xvf solana.tar.gz && rm solana.tar.gz

RUN cd solana-${SOLANA_VERSION}; ./scripts/cargo-install-all.sh .

# --- Runtime ---
FROM ubuntu:20.04

ARG TARGETARCH
ARG SOLANA_VERSION

# TODO: do not run as root

WORKDIR /root

# The Solana binaries are quite big (~750MB), consider including only the necessary ones
COPY --from=builder /usr/src/solana-${SOLANA_VERSION}/bin /usr/src/solana-${SOLANA_VERSION}/bin

ENV PATH="/usr/src/solana-${SOLANA_VERSION}/bin:$PATH"

# Use Tini as entrypoint
ARG TINI_VERSION="0.19.0"
ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-${TARGETARCH:-amd64} /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# RPC JSON
EXPOSE 8899/tcp
# RPC pubsub
EXPOSE 8900/tcp
# entrypoint
EXPOSE 8001/tcp
# (future) bank service
EXPOSE 8901/tcp
# bank service
EXPOSE 8902/tcp
# faucet
EXPOSE 9900/tcp
# tvu
EXPOSE 8000/udp
# gossip
EXPOSE 8001/udp
# tvu_forwards
EXPOSE 8002/udp
# tpu
EXPOSE 8003/udp
# tpu_forwards
EXPOSE 8004/udp
# retransmit
EXPOSE 8005/udp
# repair
EXPOSE 8006/udp
# serve_repair
EXPOSE 8007/udp
# broadcast
EXPOSE 8008/udp

CMD [ "solana" ]
