#SCRIPT CUSTOM ACCENTURE MIGRATIONS DATABASE HORUSEC PLATFORM

POSTGRES_USER="horusec"
POSTGRES_PASSWORD="horusec"
POSTGRES_HOST="172.29.57.95"
POSTGRES_PORT="5432"
POSTGRES_SSL_MODE="disable"
HORUSEC_PLATFORM_DB_NAME="horusec_db"
HORUSEC_ANALYTIC_DB_NAME="horusec_analytic_db"
HORUSEC_PLATFORM_SQL_URI="postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$HORUSEC_PLATFORM_DB_NAME?sslmode=$POSTGRES_SSL_MODE"
HORUSEC_ANALYTIC_SQL_URI="postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$HORUSEC_ANALYTIC_DB_NAME?sslmode=$POSTGRES_SSL_MODE"
PATH_PLATFORM_INSTALL="/opt/horusec-platform/migrations/source/platform"
PATH_ANALYTIC_INSTALL="/opt/horusec-platform/migrations/source/analytic"

echo "Baixando migrations"

wget https://github.com/golang-migrate/migrate/releases/download/v4.17.1/migrate.linux-amd64.tar.gz

tar -xzf migrate.linux-amd64.tar.gz

echo "Aplicando migrações para o horusec platform..."

migrate -path $PATH_PLATFORM_INSTALL -database $HORUSEC_PLATFORM_SQL_URI up

echo "Aplicando migrações para o horusec analytic..."

migrate -path $PATH_ANALYTIC_INSTALL -database $HORUSEC_ANALYTIC_SQL_URI up

rm migrate.linux-amd64.tar.gz
rm migrate
