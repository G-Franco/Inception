FROM	debian:bullseye

# Update and upgrade the system
# -y to auto accept prompts, otherwise it will wait for user input
# && \ to run multiple commands in a single RUN instruction
# to avoid creating multiple layers (which would increase the size of the image)
RUN		apt-get update && apt-get upgrade -y && \
		echo "Update and upgrade done" && \
#Install NGINX and TLS
		apt-get install -y nginx openssl && \
		echo "NGINX and TLS installed" && \
#Copy configuration files
COPY	./conf/nginx.conf /etc/nginx/nginx.conf
COPY	./conf/default.conf /etc/nginx/http.d/default.conf
#Create and process certificate
# SWITCH TO USING PREVIOULSLY CREATED CERTIFICATE
		# openssl req \
		# #Create a self-signed certificate instead of a certificate request
		# -x509 \
		# #Don't encrypt the output key, write in plain text
		# -nodes \
		# #Number of days the certificate is valid
		# -days 365 \
		# #Generate a new private key with a length of 2048 bits
		# -newkey rsa:2048 \
		# #Private key file name
		# -keyout /etc/ssl/private/nginx-selfsigned.key \
		# #Certificate file name
		# -out /etc/ssl/certs/nginx-selfsigned.crt \
		# #Set certificate's subject name
		# #C=Country, ST=State, L=Locality, O=Organization, OU=Organizational Unit, CN=Common Name
		# -subj '/C=FR/ST=Ile-de-France/L=Paris/O=42/OU=42Paris/CN=INCEPTION' && \
		# echo "Certificate created"

#Set entrypoint
#Starts NGINX, -g allows arguments to be specified
#daemon off; keeps the main process from being put into the background
#If this is not set, the container would exit immediately
ENTRYPOINT	["nginx", "-g", "daemon off;"]