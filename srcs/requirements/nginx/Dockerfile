FROM	debian:bullseye

# Update and upgrade the system
# -y to auto accept prompts, otherwise it will wait for user input
# && \ to run multiple commands in a single RUN instruction
# to avoid creating multiple layers (which would increase the size of the image)
RUN		apt-get update && apt-get upgrade -y && \
		echo "Update and upgrade done" && \
#Install NGINX and TLS
		apt-get install -y nginx openssl && \
		echo "NGINX and TLS installed"
#Copy configuration files
COPY	./conf/nginx.conf /etc/nginx/nginx.conf
COPY	./conf/default.conf /etc/nginx/http.d/default.conf

#Set entrypoint
#Starts NGINX, -g allows arguments to be specified
#daemon off; keeps the main process from being put into the background
#If this is not set, the container would exit immediately
ENTRYPOINT	["nginx", "-g", "daemon off;"]