FROM node:20-alpine AS base

# Install dependencies only when needed
FROM base AS deps
# Check <https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine> to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package.json package-lock.json* ./
COPY prisma ./prisma 

RUN npm ci;

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Generate Prisma Client
RUN npx prisma generate
RUN npm run build;

# Production image, copy all the files and run next
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
# Uncomment the following line in case you want to disable telemetry during runtime.
# ENV NEXT_TELEMETRY_DISABLED=1
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
COPY --from=builder /app/public ./public
COPY --from=builder /app/prisma ./prisma  
COPY --from=builder /app/node_modules ./node_modules  

# Set the correct permission for prerender cache
RUN mkdir .next
RUN chown nextjs:nodejs .next

# Automatically leverage output traces to reduce image size
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
USER nextjs
EXPOSE 3000
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

# Wait for the database to be ready, then run migrations
CMD ["sh", "-c", "until nc -z preciouspreemiesdashboard-kamaldb 3306; do echo 'Waiting for DB...'; sleep 3; done; npx prisma db push; npx prisma migrate deploy --schema=./prisma/schema.prisma && node server.js"]
