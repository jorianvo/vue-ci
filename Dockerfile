FROM node:12.18.2-buster-slim

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin
ENV PATH="/home/node/app/node_modules/.bin:${PATH}"

RUN mkdir /home/node/app && \ 
    mkdir /home/node/site && \
    chown -R node:node /home/node

WORKDIR /home/node/app

COPY --chown=node:node package*.json ./

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl git openssl ssh vim --no-install-recommends && \ 
    rm -rf /var/lib/apt/lists/*

USER node

RUN npm install -g npm && \
    npm install -g @aws-amplify/cli && \
    npm ci

WORKDIR /home/node/site