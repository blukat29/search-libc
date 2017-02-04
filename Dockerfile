FROM tiangolo/uwsgi-nginx-flask:flask-python3.5

# Remove sample application included in the base image.
RUN rm /app/main.py /app/uwsgi.ini

COPY app /app
COPY libc-database /libc-database
