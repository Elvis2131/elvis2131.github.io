# Use a lightweight web server image
FROM nginx:alpine

# Copy the HTML file to the web server's document root
COPY index.html /usr/share/nginx/html

# Expose port 80 for the web server
EXPOSE 80