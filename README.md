# search-libc

Web wrapper of [libc-database](https://github.com/niklasb/libc-database)

## Run as Docker container

    git submodule update --init
    docker build -t libc:latest .
    docker run -p 31337:80 -it libc:latest

## Run in debug mode

    git submodule update --init
    cd libc-database
    ./get
    cd ..
    cd app
    pip install Flask
    python manage.py
