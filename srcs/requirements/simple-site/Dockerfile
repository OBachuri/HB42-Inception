FROM busybox:1.37

WORKDIR /var/www/html

COPY site/ .

EXPOSE 80

CMD ["httpd", "-f", "-v", "-p", "80", "-h", "/var/www/html"]