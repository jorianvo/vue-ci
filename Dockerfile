FROM node:12.18.2-buster-slim

ENV PATH="/app/node_modules/.bin:${PATH}"

WORKDIR /app
COPY package*.json ./
RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git vim --no-install-recommends && \ 
    rm -rf /var/lib/apt/lists/* && \
    npm install -g npm && \
    npm ci