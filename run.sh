git submodule update --init
sudo docker build -t libc .
sudo docker run --rm -p31337:80 -it libc
