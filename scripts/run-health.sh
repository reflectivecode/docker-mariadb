#!/usr/bin/env sh
set -o errexit
set -o pipefail
set -o nounset

mysqladmin status --host=localhost --user=root --password=${MYSQL_ROOT_PASSWORD}
