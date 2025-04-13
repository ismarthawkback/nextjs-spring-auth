#!/bin/bash

# Configuration
CONTAINER_NAME=mariadb_container
MYSQL_ROOT_PASSWORD=rootpass
MYSQL_USER=user
MYSQL_PASSWORD=password
MYSQL_DATABASE=db

# Pull MariaDB image
echo "Pulling MariaDB image..."
docker pull mariadb:latest

# Remove existing container if exists
docker rm -f $CONTAINER_NAME 2>/dev/null

# Run MariaDB container
echo "Starting MariaDB container..."
docker run -d \
  --name $CONTAINER_NAME \
  -e MARIADB_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
  -p 3306:3306 \
  mariadb:latest

# Wait for MariaDB to start up
echo "Waiting for MariaDB to initialize..."
sleep 20  # adjust if needed

# Execute SQL commands inside the container
echo "Creating user and database..."
docker exec -i $CONTAINER_NAME mysql -uroot -p$MYSQL_ROOT_PASSWORD <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo "✅ MariaDB setup complete."
