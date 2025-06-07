ARG NODE_VERSION=18



# -----------------------------------------------------
FROM mcr.microsoft.com/devcontainers/typescript-node:16-bullseye AS base


# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    curl


# [Optional] Uncomment if you want to install an additional version of node using nvm
RUN  su node -c "source /usr/local/share/nvm/nvm.sh \
    && NODE_VERSION=\"$(nvm version-remote --lts ${NODE_VERSION:-16})\" \
    && nvm install \"$NODE_VERSION\" \
    && nvm alias default \"$NODE_VERSION\" \
    && nvm use default \
    && nvm install-latest-npm \
    && nvm cache clear"

# [Optional] Uncomment if you want to install more global node modules
RUN su node -c "npm install -g \
    yarn pnpm nx @nestjs/cli eslint ts-node jest"


# -----------------------------------------------------
# -----------------------------------------------------
FROM base AS cached

COPY ./.yarn .
COPY ./package*.json .
COPY ./*.lock .

RUN yarn install

ONBUILD RUN rm -rf ./.yarn/cache

# -----------------------------------------------------
# -----------------------------------------------------
FROM cached AS builder




# -----------------------------------------------------
FROM builder AS runner

ENV NODE_ENV=development

EXPOSE 4200/tcp
EXPOSE 3000/tcp





