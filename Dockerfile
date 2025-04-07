FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/mikeli0623/star-rail-warp-sim.git && \
    cd star-rail-warp-sim && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine AS build

WORKDIR /star-rail-warp-sim
COPY --from=base /git/star-rail-warp-sim .
RUN cat .yarnrc.yml
RUN corepack enable && \
    corepack install && \
    yarn && \
    export NODE_ENV=production && \
    yarn build

FROM lipanski/docker-static-website

COPY --from=build /star-rail-warp-sim/build .
