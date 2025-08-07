# Use the official NGINX base image
FROM nginx:alpine

# Remove default nginx index
RUN rm /usr/share/nginx/html/index.html

# Copy your custom index.html
COPY index.html /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start NGINX (already default command in base image)
