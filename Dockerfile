# Use the official NGINX image
FROM nginx:alpine

# Remove the default NGINX landing page
RUN rm /usr/share/nginx/html/*

# Copy custom index.html into NGINX's html folder
COPY index.html /usr/share/nginx/html/

