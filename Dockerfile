FROM httpd:2.4
 
COPY ./webserver/httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./build/web/ /usr/local/apache2/htdocs/
 
EXPOSE 80

CMD ["httpd-foreground"]