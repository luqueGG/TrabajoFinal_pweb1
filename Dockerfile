FROM ubuntu:20.04
RUN apt-get update && \
    apt-get install -y apache2 perl libapache2-mod-perl2 libcgi-pm-perl libdbi-perl mariadb-client dos2unix libjson-perl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN a2enmod cgi && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    echo '<Directory "/usr/lib/cgi-bin">' >> /etc/apache2/apache2.conf && \
    echo '    AllowOverride None' >> /etc/apache2/apache2.conf && \
    echo '    Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch' >> /etc/apache2/apache2.conf && \
    echo '    Require all granted' >> /etc/apache2/apache2.conf && \
    echo '</Directory>' >> /etc/apache2/apache2.conf && \
    echo 'AddHandler cgi-script .cgi .pl' >> /etc/apache2/apache2.conf

RUN sed -i 's/Listen 80/Listen 8085/' /etc/apache2/ports.conf

RUN echo '<VirtualHost *:8085>' >> /etc/apache2/sites-available/000-default.conf && \
        echo '    DocumentRoot /var/www/html' >> /etc/apache2/sites-available/000-default.conf && \
        echo '    <Directory /var/www/html>' >> /etc/apache2/sites-available/000-default.conf && \
        echo '        AllowOverride None' >> /etc/apache2/sites-available/000-default.conf && \
        echo '        Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch' >> /etc/apache2/sites-available/000-default.conf && \
        echo '        Require all granted' >> /etc/apache2/sites-available/000-default.conf && \
        echo '    </Directory>' >> /etc/apache2/sites-available/000-default.conf && \
        echo '</VirtualHost>' >> /etc/apache2/sites-available/000-default.conf

COPY cgi-bin/ /usr/lib/cgi-bin/
COPY html/ /var/www/html/
RUN find /usr/lib/cgi-bin/ -type f -name "*.pl" -exec dos2unix {} \; && \
    chmod +x /usr/lib/cgi-bin/*.pl

CMD ["apache2ctl", "-D", "FOREGROUND"]