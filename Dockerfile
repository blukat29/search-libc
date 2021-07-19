FROM tiangolo/uwsgi-nginx-flask:python3.8 AS base

# Install packages
RUN apt-get update \
    && apt-get install -y \
        binutils \
        cpio \
        cron \
        file \
        jq \
        rpm2cpio \
        wget \
        zstd \
    && rm -rf /var/lib/apt/lists/*

RUN echo 1
COPY libc-database /libc-database
ARG GET_DB=${GET_DB:-0}

# Get database at the time of building docker image
# Download only if $GET_DB=1
FROM base AS get-ubuntu
RUN if [ "$GET_DB" = "1" ]; then /libc-database/get ubuntu; fi

FROM base AS get-debian
RUN if [ "$GET_DB" = "1" ]; then /libc-database/get debian; fi

FROM base AS get-rpm
RUN if [ "$GET_DB" = "1" ]; then /libc-database/get rpm; fi

FROM base AS get-centos
RUN if [ "$GET_DB" = "1" ]; then /libc-database/get centos; fi

FROM base AS get-arch
RUN if [ "$GET_DB" = "1" ]; then /libc-database/get arch; fi

FROM base AS get-alpine
RUN if [ "$GET_DB" = "1" ]; then /libc-database/get alpine; fi

FROM base AS get-kali
RUN if [ "$GET_DB" = "1" ]; then /libc-database/get kali; fi

FROM base AS get-parrotsec
RUN if [ "$GET_DB" = "1" ]; then /libc-database/get parrotsec; fi

FROM base AS get-launchpad
RUN if [ "$GET_DB" = "1" ]; then /libc-database/get launchpad; fi

# The final image
FROM base

# Install cron job
COPY crontab /etc/cron.d/libc-update
RUN chmod 0644 /etc/cron.d/libc-update \
    && touch /var/log/libcdb.log

# Register cron to supervisor
COPY cron.conf /etc/supervisor/conf.d/cron.conf

# nginx.conf of the base image aliases /static to /app/static.
RUN ln -s /app/search/static /app/static
# Enable download link
COPY nginx.conf /etc/nginx/conf.d/download.conf

# Remove sample application included in the base image.
RUN rm /app/main.py /app/uwsgi.ini

# Copy application
COPY app /app
# Copy database
COPY --from=get-ubuntu    /libc-database/db /libc-database/db
COPY --from=get-debian    /libc-database/db /libc-database/db
COPY --from=get-rpm       /libc-database/db /libc-database/db
COPY --from=get-centos    /libc-database/db /libc-database/db
#COPY --from=get-arch      /libc-database/db /libc-database/db
COPY --from=get-alpine    /libc-database/db /libc-database/db
COPY --from=get-kali      /libc-database/db /libc-database/db
COPY --from=get-parrotsec /libc-database/db /libc-database/db
COPY --from=get-launchpad /libc-database/db /libc-database/db

# Generate autocomplete symbols list
RUN /app/gen_names.sh
