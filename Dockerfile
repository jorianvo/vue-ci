FROM node:10.16.0-jessie-slim

ENV PATH="/app/node_modules/.bin:${PATH}"

WORKDIR /app
COPY package*.json ./
RUN apt-get update && apt-get install -y git && \ 
    rm -rf /var/lib/apt/lists/* && \
    npm ci