#!/bin/bash
sudo docker run --name test_nginx2 \
-p 80:80 -p 443:443 \
-v /home/itavy/Projects/portal-infrastructure/nginx/test_nginx/account:/usr/share/nginx/html/account \
-v /home/itavy/Projects/portal-infrastructure/nginx/test_nginx/portal:/usr/share/nginx/html/portal \
-v /home/itavy/Projects/portal-infrastructure/nginx/test_nginx/logs:/var/log/nginx/netop \
-d portal-local-nginx
