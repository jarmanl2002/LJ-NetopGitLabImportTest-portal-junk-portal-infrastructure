#!/bin/bash
rabbitmq-plugins enable --offline rabbitmq_management;

/docker-entrypoint.sh rabbitmq-server &
