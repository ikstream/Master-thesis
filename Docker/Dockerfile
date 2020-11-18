FROM ubuntu:20.04

#Disable interactive tzdata instalaltion
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y make texlive-full latex2html

ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID -o developer
RUN useradd -m -u $UID -g $GID -s /bin/bash developer

WORKDIR /home/developer
USER developer

