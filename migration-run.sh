#!/bin/bash
#migration horusec database
#accenture custom script

POSTGRES_USER="horusec"
POSTGRES_PASSWORD="senha_usuario_horusec"
POSTGRES_HOST="ip_banco_postgres"
POSTGRES_PORT="5432"
HORUSEC_PLATFORM_DB="horusec_db"
HORUSEC_ANALYTIC_DB="horusec_analytic_db"
HORUSEC_PLATFORM_URI="postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$HORUSEC_PLATFORM_DB"
HORUSEC_ANALYTIC_URI="postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$HORUSEC_ANALYTIC_DB"
PATH_PLATFORM="/opt/horusec-platform/migrations/source/platform" #modificar caso mude o local de instalacao
PATH_ANALYTIC="/opt/horusec-platform/migrations/source/analytic" #modificar caso mude o local de instalacao

echo "Aplicando migracoes do banco de dados do horusec platform"

podman run --rm \
    -v $PATH_PLATFORM:/migrations \
    --network host migrate/migrate -path=/migrations/ -database $HORUSEC_PLATFORM_URI up

echo "Aplicando migracoes do banco de dados do horusec analytic"

podman run --rm \
    -v $PATH_ANALYTIC:/migrations \
    --network host migrate/migrate -path=/migrations/ -database $HORUSEC_ANALYTIC_URI up
