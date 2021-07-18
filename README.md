# search-libc

Web wrapper of [libc-database](https://github.com/niklasb/libc-database)

![screenshot](https://raw.githubusercontent.com/blukat29/search-libc/master/screenshot.png)

## Use existing Docker image

    docker pull blukat29/libc
    docker run -p 8080:80 -d blukat29/libc

## Run as Docker container

    git submodule update --init
    cd libc-database
    ./get all
    cd ..
    docker build -t libc:latest .
    docker run -p 31337:80 -it libc:latest

## Run in debug mode

    git submodule update --init
    cd libc-database
    ./get all
    cd ..
    cd app
    pip install Flask
    python manage.py
