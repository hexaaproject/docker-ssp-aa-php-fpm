FROM php:7.3-fpm-stretch
LABEL MAINTAINER Balázs SOLTÉSZ <solazs@sztaki.hu>

# Install some dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
                       wget \
                       unzip \
                       libicu-dev \
                       libmemcached-dev \
                       zlib1g-dev \
                       curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download and extract simplesamlphp with aa and hexaa modules
RUN cd /opt \
    && curl -L -o simplesamlphp.tar.gz https://github.com/simplesamlphp/simplesamlphp/releases/download/v1.17.1/simplesamlphp-1.17.1.tar.gz \
    && tar xzf simplesamlphp.tar.gz \
    && mv simplesamlphp-1.17.1 simplesamlphp \
    && ls -alF \
    && cd simplesamlphp/modules \
    && curl -L -o aa.tar.gz https://github.com/NIIF/simplesamlphp-module-aa/archive/v1.0.4.tar.gz \
    && tar xzf aa.tar.gz \
    && mv simplesamlphp-module-aa-1.0.4 aa \
    && curl -L -o hexaa.tar.gz https://github.com/NIIF/simplesamlphp-module-hexaa/archive/master.tar.gz \
    && tar xzf hexaa.tar.gz \
    && mv simplesamlphp-module-hexaa-master hexaa \
    && rm aa.tar.gz hexaa.tar.gz /opt/simplesamlphp.tar.gz


COPY authsources.php /opt/simplesamlphp/config/
RUN cd /opt/simplesamlphp \
    && touch modules/aa/enable \
    && cp modules/aa/config-templates/module_aa.php config/module_aa.php \
    && chown -R www-data log

COPY boot.sh /usr/local/bin/

WORKDIR /opt/simplesamlphp

CMD ["/usr/local/bin/boot.sh"]
