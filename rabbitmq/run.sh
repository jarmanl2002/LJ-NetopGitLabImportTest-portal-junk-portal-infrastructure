#!/bin/bash
apt-get update \
  && apt-get install -y wget python \
  && rm -rf /var/lib/apt/lists/* \
  && cd /root/ \
  && wget "http://localhost:15672/cli/rabbitmqadmin" \
  && chmod +x rabbitmqadmin \
  && rabbitmqctl add_vhost "netop-local" \
  && rabbitmqctl add_user "netopusr" "netoppwd" \
  && rabbitmqctl set_user_tags "netopusr" "management" \
  && rabbitmqctl set_permissions -p "netop-local" "netopusr" ".*" ".*" ".*" \
  && ./rabbitmqadmin list users
  