# Use an official Node runtime as a parent image
FROM node:14 as build

WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the app
RUN npm run build

# Use a minimal base image for the production environment
FROM node:14-alpine

WORKDIR /usr/src/app

# Copy built files from the build stage
COPY --from=build /usr/src/app/build ./build

# Install only production dependencies
COPY package*.json ./
RUN npm install --only=production

# Start the app
CMD ["node", "build/server.js"]