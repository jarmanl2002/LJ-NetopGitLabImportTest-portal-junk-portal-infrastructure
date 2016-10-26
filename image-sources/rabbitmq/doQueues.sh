#!/bin/bash
MQ_VHOST="netop-local";
MQ_USER="netopusr";
MQ_PASS="netoppwd";
MQ_EXCHANGE="netop-local-netopExchange";
MQ_ENVIROMENT="production";

## no more changes

rabbitmqctl add_vhost $MQ_VHOST;
rabbitmqctl add_user "$MQ_USER" "$MQ_PASS";
rabbitmqctl set_user_tags "$MQ_USER" "management";
rabbitmqctl set_permissions -p "$MQ_VHOST" "$MQ_USER" ".*" ".*" ".*";

MQ_PERMISSION_QUEUE="$MQ_ENVIROMENT-permissions-worker";

MQ_RK_ACCOUNT="$MQ_ENVIROMENT.portal.account";
MQ_RK_GROUP="$MQ_ENVIROMENT.portal.group";
MQ_RK_ROLE="$MQ_ENVIROMENT.portal.role";
MQ_RK_ROLEASSIGNMENT="$MQ_ENVIROMENT.portal.roleAssignment"

./rabbitmqadmin -u "$MQ_USER" -p "$MQ_PASS" --vhost="$MQ_VHOST" declare exchange name="$MQ_EXCHANGE" type="topic"

./rabbitmqadmin -u "$MQ_USER" -p "$MQ_PASS" declare queue --vhost="$MQ_VHOST" name="$MQ_PERMISSION_QUEUE" durable=true

./rabbitmqadmin -u "$MQ_USER" -p "$MQ_PASS" --vhost="$MQ_VHOST" declare binding source="$MQ_EXCHANGE" destination_type="queue" destination="$MQ_PERMISSION_QUEUE" routing_key="$MQ_RK_ACCOUNT"
./rabbitmqadmin -u "$MQ_USER" -p "$MQ_PASS" --vhost="$MQ_VHOST" declare binding source="$MQ_EXCHANGE" destination_type="queue" destination="$MQ_PERMISSION_QUEUE" routing_key="$MQ_RK_GROUP"
./rabbitmqadmin -u "$MQ_USER" -p "$MQ_PASS" --vhost="$MQ_VHOST" declare binding source="$MQ_EXCHANGE" destination_type="queue" destination="$MQ_PERMISSION_QUEUE" routing_key="$MQ_RK_ROLE"
./rabbitmqadmin -u "$MQ_USER" -p "$MQ_PASS" --vhost="$MQ_VHOST" declare binding source="$MQ_EXCHANGE" destination_type="queue" destination="$MQ_PERMISSION_QUEUE" routing_key="$MQ_RK_ROLEASSIGNMENT"
