# ---- Base Node ----
FROM node:22.5-bookworm-slim AS base
ENV NODE_ENV=development
RUN mkdir /backend && chown -R node:node /backend
WORKDIR /backend
USER node
RUN npm set progress=false && npm config set depth 0

# ---- Front ----
FROM base AS front
WORKDIR /frontend
COPY --chown=node:node ./frontend/package*.json ./
RUN yarn install
COPY --chown=node:node ./frontend ./
RUN npm run build

# ---- Release ----
FROM front AS release
WORKDIR /backend
ENV NODE_ENV=production
COPY --chown=node:node ./backend/package*.json ./
RUN yarn install
COPY --chown=node:node ./backend ./
CMD [ "node","./src/index.js"]
