FROM node:12.18.2-buster-slim

ENV PATH="/home/node/app/node_modules/.bin:${PATH}"

# We have to install the amplify cli globally (as root)
# as AWS expects it to live in /usr/bin
RUN mkdir /home/node/app && \
    chown -R node:node /home/node && \
    npm install -g npm && \
    npm install -g @aws-amplify/cli

WORKDIR /home/node/app

COPY --chown=node:node package*.json ./

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl git openssl ssh vim --no-install-recommends && \ 
    rm -rf /var/lib/apt/lists/*

USER node

RUN npm ci

ENTRYPOINT [ "bash", "-c" ]