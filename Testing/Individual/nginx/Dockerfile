FROM nginx

RUN		rm /etc/nginx/conf.d/default.conf
COPY	./default.conf /etc/nginx/conf.d
COPY	./nginx.conf /etc/nginx/nginx.conf
COPY	nginx-selfsigned.crt /etc/ssl/certs/nginx-selfsigned.crt
COPY	nginx-selfsigned.key /etc/ssl/private/nginx-selfsigned.key
COPY	index.html /usr/share/nginx/html