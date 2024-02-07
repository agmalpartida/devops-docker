FROM debian:bookworm-slim as base

LABEL maintainer="agmalpartida (agmalpartida@gmail.com)" \
    description="Docker image for my personal development environment"

# --------------------------
# SETUP
# --------------------------

RUN apt-get update && apt-get upgrade && apt-get install -y \
    sudo python3-minimal python3-pip && \
    pip3 install ansible --break-system-packages --no-cache-dir --no-warn-script-location && \
    # --------------------------
    # CREATE & CONFIGURE USER
    # --------------------------
    useradd -m -s /usr/bin/zsh -G sudo -u 1000 -U agmalpartida && \
    echo "agmalpartida ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    usermod --password "${LINUX_USER_PASSWORD}" agmalpartida

FROM base as builder

WORKDIR /home/agmalpartida

USER agmalpartida

#COPY --chown=agmalpartida:agmalpartida . dotfiles/
COPY --chown=agmalpartida:agmalpartida . /home/agmalpartida

ENV ANSIBLE_CONFIG=/home/agmalpartida/ansible/ansible.cfg \
    ANSIBLE_INVENTORY_WARNING=false

#RUN ansible-galaxy install -r dotfiles/ansible/requirements.yml -f
#RUN ansible-playbook dotfiles/ansible/base.yaml
RUN ansible-playbook ansible/base.yaml

ENTRYPOINT ["/usr/bin/zsh"]
