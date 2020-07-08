FROM ubuntu:18.04
LABEL maintainer="Nilton Oliveira <jniltinho@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -yq \
    apt-transport-https tzdata ansible ansible-lint \
    ca-certificates software-properties-common \
    curl docker.io socat sshpass yamllint \
    lxc git-core \
    vim iptables


###########
# PYTHON3 #
###########
RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip


# Wrapper docker ninja...
COPY ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

VOLUME /var/lib/docker
CMD ["wrapdocker"]


##################
# DOCKER-COMPOSE #
##################
RUN pip3 install docker-compose fabric3 pymsteams
RUN docker-compose version


###########
# KUBECTL #
###########
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && echo -e '[all:vars]\nansible_python_interpreter=/usr/bin/python3' >> /etc/ansible/hosts


RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archive/*.deb


COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
