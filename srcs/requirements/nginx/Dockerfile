FROM	debian:bullseye

#Update and upgrade the system
#-y to auto accept prompts, otherwise it will wait for user input
RUN		apt-get update && apt-get upgrade -y
RUN		echo "Update and upgrade done"

#Install NGINX and TLS
RUN		apt-get install -y nginx openssl
RUN		echo "NGINX and TLS installed"

#Create and process certificate
RUN		openssl req \
		#Create a self-signed certificate instead of a certificate request
		-x509 \
		#Don't encrypt the output key, write in plain text
		-nodes \
		#Number of days the certificate is valid
		-days 365 \
		#Generate a new private key with a length of 2048 bits
		-newkey rsa:2048 \
		#Private key file name
		-keyout /etc/ssl/private/nginx-selfsigned.key \
		#Certificate file name
		-out /etc/ssl/certs/nginx-selfsigned.crt \
		#Set certificate's subject name
		#C=Country, ST=State, L=Locality, O=Organization, OU=Organizational Unit, CN=Common Name
		-subj '/C=FR/ST=Ile-de-France/L=Paris/O=42/OU=42Paris/CN=INCEPTION'
RUN		echo "Certificate created"

# IS THIS NECCESSARY? SEEMS OVERKILL
# RUN openssl dhparam -out /etc/nginx/dhparam.pem 2048
# COPY ./conf/ssl-params.conf /etc/nginx/snippets/

# REVIEW THIS!!!!
#Copy configuration files
# COPY	./conf/default /etc/nginx/sites-available
# COPY	./conf/nginx.conf /etc/nginx/nginx.conf
# COPY	./conf/default.conf /etc/nginx/http.d/default.conf
# COPY	./conf/adminer.conf    /etc/nginx/sites-available/
# COPY	./conf/subdomain.conf  /etc/nginx/sites-available/

# RUN  ln -s /etc/nginx/sites-available/adminer.conf /etc/nginx/sites-enabled/
# RUN  ln -s /etc/nginx/sites-available/subdomain.conf /etc/nginx/sites-enabled/

#Set entrypoint
#Starts NGINX, -g allows arguments to be specified
#daemon off; keeps the main process from being put into the background
#If this is not set, the container would exit immediately
ENTRYPOINT	["nginx", "-g", "daemon off;"]