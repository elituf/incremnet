# ----- build -----
FROM node:25-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY tsconfig.json ./
COPY src/ ./src/
COPY templates/ ./templates/
RUN npm run build

# ----- prod -----
FROM node:25-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY --from=builder /app/dist/ ./dist/
COPY --from=builder /app/templates/ ./templates/
RUN mkdir -p /data
CMD ["node", "dist/main.js"]
