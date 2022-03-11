#!/bin/sh

REPO=eqlabs/solana
VERSION=1.9.11

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg SOLANA_VERSION=${VERSION} \
  -t ${REPO}:${VERSION} \
  --push \
  .
