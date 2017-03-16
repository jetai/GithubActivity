#!/usr/bin/env bash
#/bin/bash
# This shell is to swap from web2 to web1
cd /etc/nginx
sed -e s?$1:8080/activity/?$2:8080/activity/? <nginx.conf > /tmp/xxx
cp /tmp/xxx nginx.conf
service nginx reload