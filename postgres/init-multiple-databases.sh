#!/bin/bash
set -e

# Create Certificate DB and user
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER "$CERTIFICATE_DB_USER" WITH PASSWORD '$CERTIFICATE_DB_PASSWORD';
    CREATE DATABASE "$CERTIFICATE_DB_NAME" OWNER "$CERTIFICATE_DB_USER";
    GRANT ALL PRIVILEGES ON DATABASE "$CERTIFICATE_DB_NAME" TO "$CERTIFICATE_DB_USER";
EOSQL

# Run the schema for the specific database
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$CERTIFICATE_DB_NAME" -f /docker-entrypoint-initdb.d/certificate_schema.sql

# Ensure the user has privileges on all tables in the public schema
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$CERTIFICATE_DB_NAME" -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO \"$CERTIFICATE_DB_USER\";"

# Ensure the user has privileges on all sequences in the public schema
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$CERTIFICATE_DB_NAME" -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO \"$CERTIFICATE_DB_USER\";"

# Create Decrypter DB and User
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER "$DECRYPTER_DB_USER" WITH PASSWORD '$DECRYPTER_DB_PASSWORD';
    CREATE DATABASE "$DECRYPTER_DB_NAME" OWNER "$DECRYPTER_DB_USER";
    GRANT ALL PRIVILEGES ON DATABASE "$DECRYPTER_DB_NAME" TO "$DECRYPTER_DB_USER";
EOSQL

# Run the schema for the specific database
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DECRYPTER_DB_NAME" -f /docker-entrypoint-initdb.d/decrypter_schema.sql

# Ensure the user has privileges on all tables in the public schema
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DECRYPTER_DB_NAME" -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO \"$DECRYPTER_DB_USER\";"

# Ensure the user has privileges on all sequences in the public schema
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DECRYPTER_DB_NAME" -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO \"$DECRYPTER_DB_USER\";"