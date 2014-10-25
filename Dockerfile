# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM ubuntu:14.04
# MAINTAINER Ervin Varga <ervin.varga@gmail.com>
# Not trying to steal credit! But support for this should go to me :)
MAINTAINER Will Dietz <w@wdtz.org>

# Make sure the package repository is up to date.
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update

# Install a basic SSH server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Install JDK 7 (latest edition)
RUN apt-get install -y --no-install-recommends openjdk-7-jdk

# Add user jenkins to the image
RUN adduser --quiet jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

# Build deps
RUN apt-get install -y build-essential git vim cmake
RUN apt-get install -y golang libboost1.55-dev


