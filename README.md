# uru-information-security-tender

**Note:** Archived and read-only. Kept for reference from the Information Security college course.

Tender project for the Information Security college course at URU. It implements a simulated tender/bidding workflow secured with PKI: a certificate authority issues organization certificates, bidders encrypt sealed bids with their certificate, and a decrypter service validates and opens bids only after certificate checks.

## Architecture

Docker Compose orchestration of several services, most pulled in as git submodules:

- **`certificate-grpc`** (submodule) — issues/manages organization certificates and keys, Postgres-backed. Port `50053`.
- **`encrypter-grpc`** (submodule) — encrypts bidder files against certificate keys. Port `50051`.
- **`decrypter-grpc`** (submodule) — verifies certificates and decrypts/stores submitted files, Postgres-backed. Port `50052`.
- **`admin-app`** / **`bidder-app`** / **`certificate-app`** (submodules) — the admin, bidder and certificate-facing apps. Ports `8501`/`8502`/`8503`.
- **`postgres`** — shared instance seeded with the certificate and decrypter schemas. Port `5432`.

RSA key pairs for the certificate authority, encrypter and decrypter are generated locally (`generate_keys.bat`) and mounted into each container as `.pem` files.

## Database schema

Initialized via `postgres/init-multiple-databases.sh`:

- `postgres/certificate_schema.sql` — `organizations_keys` and `issued_certificates` tables, plus procedures to upsert keys, issue/revoke certificates and check validity.
- `postgres/decrypter_schema.sql` — `encrypted_files` table, plus procedures to add/remove records and list active files.

## Configuration

Copy `.env.example` to `.env` and fill in: `POSTGRES_SUPERUSER_PASSWORD`, `CERTIFICATE_DB_NAME/USER/PASSWORD`, `DECRYPTER_DB_NAME/USER/PASSWORD`, `ISSUER_COMMON_NAME/ORGANIZATION/ORGANIZATIONAL_UNIT/LOCALITY/STATE/COUNTRY`, `CERTIFICATE_VALIDITY_DAYS`.

## Running

1. `git submodule update --init --recursive` (or `update_submodules.bat`).
2. Generate the PKI key pairs: `generate_keys.bat`.
3. Create the Docker volume directories: `prepare_docker.sh` / `.bat`.
4. Provide `.env` (see Configuration).
5. `docker compose up --build`.

## License

GNU General Public License v3.0 (see `LICENSE`).
