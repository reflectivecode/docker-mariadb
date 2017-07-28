#!/usr/bin/env sh
set -o errexit
set -o pipefail
set -o nounset

echo "[i] set ownership of ${MYSQL_DATA_DIR} to ${USER}"
chown -R ${USER}:${USER} "${MYSQL_DATA_DIR}"
chmod 700 -R "${MYSQL_DATA_DIR}"

echo "[i] set ownership of ${MYSQL_SOCKET_DIR} to ${USER}"
chown -R ${USER}:${USER} ${MYSQL_SOCKET_DIR}

if [ -d ${MYSQL_DATA_DIR}/mysql ]; then
    echo "[i] data directory already present, skipping creation"
else
    echo "[i] data directory not found, starting creation "

    echo "[i] creating initial DBs"
    mysql_install_db --user=${USER} > /dev/null

    echo "[i] start db without networking"
    mysqld --user=${USER} --skip-networking &
    pid="$!"

    for i in {30..0}; do
        if echo 'SELECT 1' | mysql &> /dev/null; then
            break
        fi
        echo '[i] MySQL init process in progress...'
        sleep 1
    done
    if [ "$i" = 0 ]; then
        echo >&2 '[e] MySQL init process failed.'
        exit 1
    fi
    echo "[i] db is ready"

    echo "[i] Deleting users, adding root user, deleting test database"
    mysql <<EOF
DELETE FROM mysql.user ;
CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOF

    echo "[i] stopping db"
    if ! kill -s TERM "$pid" || ! wait "$pid"; then
        echo >&2 '[e] MySQL init process failed.'
        exit 1
    fi
    echo "[i] db stopped"
    echo "[i] creation complete"
fi

echo "[i] execute mysqld as ${USER}"
exec mysqld --user=${USER} --console
