#!/usr/bin/env bash
# -------------------------------------------------------------------
# Copyright (c) 2015 Manoel Domingues.  All Rights Reserved.
#
# This file is provided to you under the Apache License,
# Version 2.0 (the "License"); you may not use this file
# except in compliance with the License.  You may obtain
# a copy of the License at
#
#   http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# -------------------------------------------------------------------

# Fix error message in system
sudo locale-gen UTF-8

# Updating repos
sudo apt-get -y update

# Generate root password
export ROOT_PASS="$RANDOM-$RANDOM-$RANDOM-$RANDOM"

# Define environment variables
export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $ROOT_PASS"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $ROOT_PASS"

# Installing mysql
sudo apt-get -y --force-yes install mysql-server 

# Set bind-address
sudo sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# Define secure password for root
mysql -u root -p$ROOT_PASS -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$ROOT_PASS' WITH GRANT OPTION; FLUSH PRIVILEGES;"

# Restart mysql
sudo /etc/init.d/mysql restart

# Show root password for user
echo "=> MYSQL ROOT PASS: $ROOT_PASS" 
