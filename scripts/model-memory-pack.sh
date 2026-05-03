#!/usr/bin/env bash
# model-memory-pack.sh — Insert a model memory artifact into SQLite.
# Usage: bash scripts/model-memory-pack.sh <db_path> <artifact_path> [operator_id]
set -euo pipefail

DB="${1:?Usage: model-memory-pack.sh <db_path> <artifact_path> [operator_id]}"
ARTIFACT="${2:?artifact path required}"
OPERATOR_ID="${3:-}"

if [ ! -f "$ARTIFACT" ]; then
    echo "[model-memory-pack] ERROR: artifact not found: $ARTIFACT" >&2
    exit 1
fi

EXT=".${ARTIFACT##*.}"
# Normalise extension with leading dot
case "$EXT" in
    .akmodel|.bfmodel|.akfpqx|.bffpqx) ;;
    *) echo "[model-memory-pack] ERROR: unsupported extension '$EXT' (expected .akmodel/.bfmodel/.akfpqx/.bffpqx)" >&2; exit 1 ;;
esac

NAME=$(basename "$ARTIFACT")
SIZE=$(wc -c < "$ARTIFACT" | tr -d ' ')
SHA=$(shasum -a 256 "$ARTIFACT" | awk '{print $1}')

echo "[model-memory-pack] Packing: $NAME ($SIZE bytes, sha256=$SHA)"

sqlite3 "$DB" <<SQL
INSERT INTO model_memory (artifact_name, artifact_ext, operator_id, size_bytes, sha256, payload)
VALUES (
    '$NAME',
    '$EXT',
    $([ -n "$OPERATOR_ID" ] && echo "'$OPERATOR_ID'" || echo "NULL"),
    $SIZE,
    '$SHA',
    readfile('$ARTIFACT')
);
SQL

echo "[model-memory-pack] Inserted. Row count: $(sqlite3 "$DB" 'SELECT count(*) FROM model_memory;')"
echo "[model-memory-pack] PASS"
