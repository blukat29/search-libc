git submodule update --init
sudo docker build -t libc .
sudo docker run --rm -p 8080:80 -it libc
