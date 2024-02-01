# Use a Node.js base image
FROM node:latest

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install JavaScript dependencies
RUN npm install

# Install PureScript and Spago globally
RUN npm install -g purescript spago

# Copy PureScript project files
COPY src/ src/
COPY test/ test/
COPY spago.dhall .
COPY packages.dhall .

# Install PureScript dependencies
RUN spago install

# Copy Parcel configuration files (if any)
COPY .parcelrc ./

# Copy your HTML and JavaScript files
COPY index.html .
COPY main.js .

# Build the project
RUN npm run build

# Expose the port your app runs on
EXPOSE 1234

# Define the command to run your app (replace with your run script)
CMD ["npm", "run", "start"]