FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/mikeli0623/star-rail-warp-sim.git && \
    cd star-rail-warp-sim && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM --platform=$BUILDPLATFORM node:24-alpine AS build

WORKDIR /star-rail-warp-sim
COPY --from=base /git/star-rail-warp-sim .
RUN corepack enable && \
    corepack install && \
    yarn install --frozen-lockfile && \
    yarn build

FROM joseluisq/static-web-server

COPY --from=build /star-rail-warp-sim/build ./public
