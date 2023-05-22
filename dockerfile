# Use a lightweight web server image
FROM nginx:alpine

# Copy the HTML file to the web server's document root
COPY index.html /usr/share/nginx/html

# Expose port 80 for the web server
EXPOSE 80

aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 923674977312.dkr.ecr.eu-west-1.amazonaws.com
docker-compose build --no-cache