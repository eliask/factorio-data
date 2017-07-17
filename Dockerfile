FROM node:8

RUN apt-get update && apt-get install -y \
    g++ \
    liblua5.1-0-dev \
    lua5.1 \
    make \
    pkg-config \
    python-minimal \
 && rm -rf /var/lib/apt/lists/*

ADD factorio-recipe-extraction /package
RUN cd /package; chown node \
    /package \
    /usr/local/bin \
    /usr/local/lib/node_modules\
    ; su node -c 'npm install --production -g'
