FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# 32 bit
RUN dpkg --add-architecture i386
RUN apt-get update -qyy
RUN apt-get install -qyy \
  python \
  python-pip \
  nano \
  vim \
  gdb \
  gdbserver \
  gdb-multiarch \
  git \
  make \
  gcc \
  g++ \
  flex \
  bison \
  wget \
  curl \
  cmake \
  pkg-config \
#  libc6:i368 \
  libstdc++6:i386 \
  binutils 

# setup pwndb
RUN mkdir /pwndbg
RUN cd /pwndbg && git clone https://github.com/pwndbg/pwndbg && cd pwndbg && ./setup.sh 

RUN python -m pip install pwntools ROPgadget

RUN apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Main Workspace
RUN mkdir /ctf && chmod 777 /ctf
WORKDIR /ctf
