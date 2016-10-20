#!/bin/bash
echo "Waiting for server to start";
MQS_STATUS=1;
MQS_CMD="/root/rabbitmqadmin show overview";
until [ $MQS_STATUS -eq 0 ]; do
#  $MQS_CMD &>/dev/null;
  $MQS_CMD;
  MQS_STATUS=$?;
done
echo "Server has started";
