FROM tiangolo/uwsgi-nginx-flask:python3.8

# Remove sample application included in the base image.
RUN rm /app/main.py /app/uwsgi.ini

# Install packages
# TODO: install zstd
RUN apt-get update \
    && apt-get install -y \
        binutils \
        cpio \
        cron \
        file \
        jq \
        rpm2cpio \
        wget \
    && rm -rf /var/lib/apt/lists/*

# Install cron job
COPY crontab /etc/cron.d/libc-update
RUN chmod 0644 /etc/cron.d/libc-update \
    && touch /var/log/libcdb.log

# Register cron to supervisor
COPY cron.conf /etc/supervisor/conf.d/cron.conf

# Copy application
COPY app /app
COPY libc-database /libc-database

# Generate autocomplete symbols list
RUN /app/gen_names.sh

# nginx.conf of the base image aliases /static to /app/static.
RUN ln -s /app/search/static /app/static
# Enable download link
COPY nginx.conf /etc/nginx/conf.d/download.conf
