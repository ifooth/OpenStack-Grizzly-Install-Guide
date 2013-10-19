#!/bin/sh
#
# Keystone basic configuration 
# joe lei

# drop keystone db
mysql -uroot -proot -e "drop database if exists keystone;create database keystone;"
keystone-manage db_sync

HOST_IP=10.10.1.100
export SERVICE_TOKEN="ADMIN"
export SERVICE_ENDPOINT="http://${HOST_IP}:35357/v2.0"

ADMIN=admin
SERVICE=service
ADMIN_PASSWORD=-admin_pass
SERVICE_PASSWORD=service_pass

# Tenants
keystone tenant-create --name=$ADMIN
keystone tenant-create --name=$SERVICE

# Roles
keystone role-create --name=$ADMIN
keystone role-create --name=$SERVICE

# Users
# admin
keystone user-create --name=admin --pass="$ADMIN_PASSWORD" --email=admin@domain.com
keystone user-role-add --user $ADMIN --role $ADMIN --tenant $ADMIN
# nova
keystone user-create --name=nova --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE --email=nova@domain.com
keystone user-role-add --user nova --role $SERVICE --tenant $SERVICE
# glance
keystone user-create --name=glance --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE --email=glance@domain.com
keystone user-role-add --user glance --role $SERVICE --tenant $SERVICE
# neutron
keystone user-create --name=neutron --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE --email=neutron@domain.com
keystone user-role-add --user neutron --role $SERVICE --tenant $SERVICE
