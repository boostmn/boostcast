#!/bin/bash

if [ ! -f /etc/supervisor/minimal.conf.d/mariadb.conf ]; then
    echo "MariaDB disabled. Skipping DB initialization..."
    exit 0
fi

export MARIADB_AUTO_UPGRADE=1

source /usr/local/bin/db_entrypoint.sh

set -- mariadbd

mysql_note "Initial DB setup..."

mysql_check_config "$@"
# Load various environment variables
docker_setup_env "$@"

# Create DB directories
mkdir -p "$DATADIR"
if [ "$(id -u)" = "0" ]; then
  # this will cause less disk access than `chown -R`
  find "$DATADIR" \! -user mysql -exec chown mysql: '{}' +
  # See https://github.com/MariaDB/mariadb-docker/issues/363
  find "${SOCKET%/*}" -maxdepth 0 \! -user mysql -exec chown mysql: '{}' \;
fi

# If container is started as root user, restart as dedicated mysql user
if [ "$(id -u)" = "0" ]; then
    mysql_note "Switching to dedicated user 'mysql'"
    exec gosu mysql "${BASH_SOURCE[0]}" "$@"
fi

# there's no database, so it needs to be initialized
if [ -z "$DATABASE_ALREADY_EXISTS" ]; then
    docker_verify_minimum_env
    docker_mariadb_init "$@"
# MDEV-27636 mariadb_upgrade --check-if-upgrade-is-needed cannot be run offline
#elif mysql_upgrade --check-if-upgrade-is-needed; then
elif _check_if_upgrade_is_needed; then
    docker_mariadb_upgrade "$@"
fi


# #!/bin/bash

# if [ ! -f /etc/supervisor/minimal.conf.d/mariadb.conf ]; then
#     echo "MariaDB disabled. Skipping DB initialization..."
#     exit 0
# fi

# export MARIADB_AUTO_UPGRADE=1

# source /usr/local/bin/db_entrypoint.sh

# # set -- mysqld
# set -- mariadbd

# mysql_note "Initial DB setup..."

# mysql_check_config "$@"
# # Load various environment variables
# docker_setup_env "$@"
# docker_create_db_directories

# # If container is started as root user, restart as dedicated mysql user
# if [ "$(id -u)" = "0" ]; then
#     mysql_note "Switching to dedicated user 'mysql'"
#     exec gosu mysql "${BASH_SOURCE[0]}" "$@"
# fi

# # there's no database, so it needs to be initialized
# if [ -z "$DATABASE_ALREADY_EXISTS" ]; then
#     docker_verify_minimum_env

#     # check dir permissions to reduce likelihood of half-initialized database
#     ls /docker-entrypoint-initdb.d/ > /dev/null

#     docker_init_database_dir "$@"

#     mysql_note "Starting temporary server"
#     docker_temp_server_start "$@"
#     mysql_note "Temporary server started."

#     docker_setup_db
#     docker_process_init_files /docker-entrypoint-initdb.d/*

#     mysql_note "Stopping temporary server"
#     docker_temp_server_stop
#     mysql_note "Temporary server stopped"

#     echo
#     mysql_note "MariaDB init process done. Ready for start up."
#     echo
# # MDEV-27636 mariadb_upgrade --check-if-upgrade-is-needed cannot be run offline
# #elif mysql_upgrade --check-if-upgrade-is-needed; then
# elif _check_if_upgrade_is_needed; then
#     docker_mariadb_upgrade "$@"
# fi
