######## nginx ########

FROM nginx:1.27

RUN mkdir -p /etc/nginx/ssl

COPY tools/nginx.conf /etc/nginx/nginx.conf

COPY tools/ssl.key /etc/nginx/ssl/ssl.key

COPY tools/ssl.crt /etc/nginx/ssl/ssl.crt
