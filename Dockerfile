FROM ubuntu:18.04
LABEL maintainer="Nilton Oliveira <jniltinho@gmail.com>"

ARG KUBECTL_VERSION=1.18.5

ENV DEBIAN_FRONTEND noninteractive

## Env Ansible
ENV ANSIBLE_HOST_KEY_CHECKING False
ENV ANSIBLE_REMOTE_PORT 22
ENV ANSIBLE_REMOTE_USER root

RUN apt-get update && apt-get install -yq fabric \
    apt-transport-https tzdata ansible ansible-lint \
    ca-certificates software-properties-common \
    curl docker.io socat sshpass yamllint \
    git iptables python3-pip docker-compose


###########
# PYTHON3 #
###########
RUN cd /usr/local/bin && ln -s /usr/bin/python3 python



# Wrapper docker ninja...
COPY ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

VOLUME /var/lib/docker
CMD ["wrapdocker"]


RUN curl -#kL -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.8.0/yq_linux_amd64 \
    && curl -#kL -o /usr/local/bin/katafygio https://github.com/bpineau/katafygio/releases/download/v0.8.3/katafygio_0.8.3_linux_amd64 \
    && curl -#kL -o /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 \
    && curl -LO https://github.com/tdewolff/minify/releases/download/v2.9.10/minify_linux_amd64.tar.gz \
    && mkdir minify_ && tar -xf minify_linux_amd64.tar.gz -C minify_ \
    && mv minify_/minify /usr/local/bin/ && rm -rf *.tar.gz minify_ \
    && chmod +x /usr/local/bin/yq /usr/local/bin/jq /usr/local/bin/katafygio


###########
# KUBECTL #
###########
RUN curl -LO https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl


RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archive/*.deb


COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
