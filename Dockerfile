# Use an official CentOS 7 runtime as a parent image
FROM centos:7

# Install required packages
RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y nodejs npm && \
    yum clean all

# Set the working directory to /app
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the application
RUN npm run build

# Expose port 80 to the outside world
EXPOSE 80

# Start the application
CMD ["npm", "start"]
