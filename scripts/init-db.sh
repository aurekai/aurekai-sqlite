#!/usr/bin/env bash
# init-db.sh — Initialize an Aurekai SQLite database with all schemas.
# Usage: bash scripts/init-db.sh <db_path>
set -euo pipefail

DB="${1:?Usage: init-db.sh <db_path>}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SQL_DIR="$SCRIPT_DIR/../sql"

echo "[aurekai-sqlite] Initializing database: $DB"
for schema in \
    schema-model-memory.sql \
    schema-sae.sql \
    schema-semantic-cache.sql \
    schema-manifests.sql \
    schema-proof-bundles.sql; do
    echo "  Applying $schema ..."
    sqlite3 "$DB" < "$SQL_DIR/$schema"
done

echo "[aurekai-sqlite] Schema tables created:"
sqlite3 "$DB" ".tables"
echo "[aurekai-sqlite] Done."
