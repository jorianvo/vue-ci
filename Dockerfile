FROM node:10.16.0-jessie-slim

ENV PATH="/app/node_modules/.bin:${PATH}"

WORKDIR /app
COPY package*.json ./
RUN npm ci