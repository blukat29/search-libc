git submodule update --init
sudo docker build -t libc .
sudo docker run --name ll --rm -p31337:80 -it libc
