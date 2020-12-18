FROM ubuntu:18.04
LABEL maintainer="Nilton Oliveira <jniltinho@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

## Env Ansible
ENV ANSIBLE_HOST_KEY_CHECKING False
ENV ANSIBLE_REMOTE_PORT 22
ENV ANSIBLE_REMOTE_USER root

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


RUN curl -#kL -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/3.4.1/yq_linux_amd64 \
    && curl -#kL -o /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 \
    && curl -LO https://github.com/tdewolff/minify/releases/download/v2.9.10/minify_linux_amd64.tar.gz \
    && mkdir minify_ && tar -xf minify_linux_amd64.tar.gz -C minify_ \
    && mv minify_/minify /usr/local/bin/ && rm -rf *.tar.gz minify_ \
    && chmod +x /usr/local/bin/yq /usr/local/bin/jq


###########
# KUBECTL #
###########
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl


RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archive/*.deb


COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
