FROM node:14.15.1-buster

ENV PATH="/home/node/app/node_modules/.bin:${PATH}"

# We have to install the amplify cli globally (as root)
# as AWS expects it to live in /usr/bin
RUN mkdir /home/node/app && \
    chown -R node:node /home/node && \
    npm install -g @aws-amplify/cli && \
    npm install -g @vue/cli && \
    npm install -g gulp-cli && \
    npm install -g netlify-cli && \
    npm install -g npm

WORKDIR /home/node/app

COPY --chown=node:node package*.json ./

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl git openssl ssh vim --no-install-recommends && \ 
    rm -rf /var/lib/apt/lists/*

USER node

RUN npm ci

ENTRYPOINT [ "bash", "-c" ]