# Jenkins slave container for LLVM Research @ UIUC
FROM ubuntu:utopic
# Original MAINTAINER Ervin Varga <ervin.varga@gmail.com>
# Not trying to steal credit! But support for this should go to me :)
MAINTAINER Will Dietz <w@wdtz.org>

# Prefer local UIUC mirror (cosmos):
RUN sed -i.docker.orig /etc/apt/sources.list \
	-e 's@http://archive\.ubuntu\.com/ubuntu@http://cosmos.cites.illinois.edu/pub/ubuntu@'

# Make sure the package repository is up to date.
RUN apt-get update

# Install a basic SSH server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

# Install JDK 7
RUN apt-get install -y --no-install-recommends openjdk-7-jdk

# Add user jenkins to the image
RUN adduser --quiet jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

COPY docker-slave-ssh /home/jenkins/.ssh
RUN chown jenkins:jenkins -R /home/jenkins/.ssh

# Build deps for our research software
RUN apt-get install -y build-essential git vim cmake
RUN apt-get install -y golang libboost1.55-dev


