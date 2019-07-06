FROM node:10.16.0-jessie-slim

WORKDIR /app
COPY package*.json ./
RUN npm ci